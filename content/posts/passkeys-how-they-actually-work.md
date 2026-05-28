---
title: "Passkeys: How They Actually Work"
date: 2026-05-09
draft: false
tags: ["passkeys", "webauthn", "fido2", "authentication", "phishing"]
categories: ["Latest IT and Cybersecurity Technology", "Cybersecurity"]
summary: "Passkeys are the most consequential change to consumer authentication in twenty years. A short technical tour of what they are, why they kill phishing, and what they don't fix."
---

Passwords have been broken for two decades. Everyone knows it. The reason we still use them is that every replacement has been worse — clunky, expensive, vendor-locked, or all three. Passkeys are the first replacement that has a real shot, and they're already shipping in iOS, Android, Windows, macOS, and every major browser.

This post is the technical tour I'd give a colleague who wants to understand passkeys without reading the WebAuthn spec.

## What a passkey actually is

A **passkey is an asymmetric key pair** generated for one website. The private key stays on your device (or your password manager). The public key is sent to the website at registration. To sign in later, the website sends a random challenge, your device signs it with the private key, and the website verifies the signature with the stored public key.

That's it. There is no shared secret. The website never sees anything reusable. The user types nothing.

Under the hood, passkeys are **FIDO2 / WebAuthn credentials**, with the addition that they're allowed (and expected) to **sync across the user's devices** via a platform credential manager (iCloud Keychain, Google Password Manager, Windows Hello) or a third-party password manager (1Password, Bitwarden, Dashlane, etc.).

## Why this kills phishing

Passwords are phishable because the user types the same secret into any site that asks. The attacker stands up `paypa1.com`, the user types their PayPal password into it, the attacker replays it on the real PayPal.

Passkeys are bound to the **origin** — the domain the credential was registered against. When the user lands on `paypa1.com`, the browser looks for a passkey registered for `paypa1.com`, finds none, and doesn't sign anything. The user *cannot* hand the credential to the wrong site, even if they try. The phishing attack has nowhere to go.

This is the single biggest deal. Credential phishing accounts for the majority of account takeovers. Passkeys break the mechanism at the protocol level.

## The two flavors

There are two implementations worth knowing about:

**Synced passkeys (the consumer default).** The private key syncs through a platform or password-manager cloud. Convenient. Recoverable if you lose your phone. The credential's confidentiality depends on the strength of your platform account (Apple ID, Google account) or your password manager.

**Device-bound passkeys (also called hardware-bound or "discoverable credentials" tied to a security key).** The private key never leaves a piece of hardware — a YubiKey, a phone's secure enclave with sync disabled, etc. Higher assurance. No cloud recovery. Right for admin accounts and anything else where you want the assurance level of a hardware token.

Most relying parties accept both. Some high-security ones (corporate admin, government, banking) require hardware-bound.

## How sign-in flows

1. You go to `example.com/login`.
2. The site asks the browser for a passkey for `example.com`.
3. The browser finds one (locally or via a synced password manager) and asks you to authorize — Face ID, Touch ID, Windows Hello, or device PIN.
4. The local biometric or PIN unlocks access to the private key.
5. The browser signs the site's challenge and sends the signature.
6. The site verifies with the stored public key, and you're in.

The biometric never leaves your device. The site never sees it. The biometric is purely local user verification.

## What passkeys don't fix

- **They don't replace MFA conceptually — they fold it in.** Possession (the device) + biometric or PIN (the user verification) makes a passkey a multi-factor credential on its own. But this is multi-factor *to your device*, not necessarily *to the relying party*. Sites that want a second factor for high-risk actions still need to require one.
- **They don't fix account recovery.** If you lose all your devices and your platform account is compromised, recovery is still the weakest link. Most breaches that survive passkeys will be account-recovery flows.
- **They don't fix authorization.** You're authenticated. Whether you're allowed to do the thing is a separate problem with separate bugs.
- **They don't fix session theft.** Once you're signed in, the session cookie is still a bearer token. Token-binding standards exist but adoption is uneven.
- **They don't help if the relying party stores its own bypass mechanism poorly.** A passkey-protected account with a "forgot password — email me a link" recovery flow is only as strong as the email.

## How to roll them out

If you run a service:

- **Add passkey support alongside passwords** first. Most users won't switch on day one.
- **Default new accounts to passkey-first** flows. New users have no muscle memory to fight.
- **Offer passkeys as the additional factor** for existing password users; pull them up the assurance ladder.
- **Plan account-recovery flows carefully.** Don't undo the security gain with a soft recovery flow.
- **Read the [FIDO Alliance UX guidelines](https://fidoalliance.org/ux-guidelines/).** Bad UX is the #1 reason rollouts stall.

If you're an end user:

- **Turn them on** for accounts that support them. GitHub, Google, Microsoft, Apple, most banks, most major sites.
- **Pick a credential store** intentionally. Platform keychain is fine for most people. A password manager that does passkeys is better if you want cross-platform.
- **Keep a backup hardware key** for your most important accounts (email, password manager). Store it somewhere offline.
- **Don't disable your password until you've signed in with the passkey a few times** and understand the recovery flow.

## What this means in five years

If adoption continues on its current curve, account-takeover via credential phishing will become a niche attack — still possible against laggards, but not the volume play it is today. Attackers will shift toward session theft, OAuth abuse, and supply chain compromise of the platforms themselves. Those attacks are harder, more expensive, and target far fewer people.

The 2020s authentication transition is the most significant security-positive change consumers will see this decade. It's worth understanding well enough to advocate for, deploy carefully, and explain to family members when their bank emails them about it.

## Further reading

- The WebAuthn Level 3 spec is dense but readable.
- Adam Langley's blog (`imperialviolet.org`) has the best explainer-style writing on the cryptographic side.
- FIDO Alliance documentation is good — they're the standards body and they write for developers, not marketers.
