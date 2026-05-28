---
title: "Post-Quantum Cryptography: The 2026-2027 Migration Deadlines That Actually Bite"
date: 2026-05-02
draft: false
tags: ["post-quantum", "pqc", "ml-kem", "ml-dsa", "nist", "fips-203", "fips-204", "cnsa-2", "tls", "openssl"]
categories: ["Latest IT and Cybersecurity Technology"]
summary: "ML-KEM and ML-DSA are standards. CNSA 2.0 mandates start January 2027. FIPS 140-2 goes Historical on September 21, 2026. Akamai's hybrid PQ defaults in February 2026. A practitioner's guide to what's actually happening and what to do this year."
---

The post-quantum cryptography conversation has spent ten years in the "we should think about this someday" bucket. Someday is now.

This post is the deep dive on where the migration actually stands in 2026, with the deadlines that affect federal contractors, vendors selling to regulated industries, and engineers who care about getting ahead of the curve. The dates in this post are real and they are close enough to matter.

## What's standardized and what's not

In August 2024, NIST finalized the first three post-quantum standards:

- **[FIPS 203 — ML-KEM](https://csrc.nist.gov/pubs/fips/203/final)** (Module-Lattice-Based Key Encapsulation Mechanism). Derived from Kyber. This is the *key exchange* algorithm. It's the replacement for the ECDH/X25519 work in TLS, IPsec, SSH, etc.

- **[FIPS 204 — ML-DSA](https://csrc.nist.gov/pubs/fips/204/final)** (Module-Lattice-Based Digital Signature Algorithm). Derived from Dilithium. This is the *signature* algorithm. It's the replacement for ECDSA and RSA signatures in TLS certificates, code signing, JWT signing, document signing, and authentication systems.

- **[FIPS 205 — SLH-DSA](https://csrc.nist.gov/pubs/fips/205/final)** (Stateless Hash-Based Digital Signature Algorithm). Derived from SPHINCS+. The hash-based alternative signature. Slower than ML-DSA but rests on a different and more conservative cryptographic assumption — useful as a backup standard and for systems where ML-DSA's lattice-based security feels too new to bet on.

A fourth standard for key encapsulation, **HQC**, was selected in 2025 to provide a non-lattice alternative to ML-KEM, with a final FIPS publication expected in 2026-2027.

**What's not standardized yet:**

- A drop-in PQ replacement for symmetric key derivation. Existing KDFs (HKDF, etc.) are fine — symmetric cryptography is not particularly threatened by quantum attacks. AES-256 is the recommendation for new work.
- A complete PQ TLS profile that everyone agrees on. The IETF is working on it; in the meantime, hybrid (classical + PQ) modes are the norm.
- A consensus on post-quantum code-signing schemes for resource-constrained devices, where ML-DSA signature sizes are uncomfortable.

## The deadlines that bite

There are four dates on the calendar that matter in 2026-2027. Each affects a different population of practitioners.

### September 21, 2026 — FIPS 140-2 goes Historical

On this date, **NIST moves all remaining FIPS 140-2 certificates to Historical status**. After this, only **FIPS 140-3** validated modules may be used for new federal procurement and federal-aligned work.

This is not directly about PQC. But many of the PQ-capable cryptographic modules being validated now are FIPS 140-3 modules, and the migration to 140-3 is paired with the migration to PQ algorithms in many vendor roadmaps. If your organization sells to federal customers, this date is on your radar.

### January 2027 — CNSA 2.0 mandates begin for National Security Systems

The U.S. **Commercial National Security Algorithm Suite 2.0 (CNSA 2.0)** is the mandatory suite for National Security Systems (NSS). The hard deadline is **January 2027** for new acquisitions, with the algorithm suite being:

- **ML-KEM-1024** for key exchange
- **ML-DSA-87** for digital signatures
- **AES-256** for symmetric encryption
- **SHA-384/512** for hashing

If you build products that sell into NSS environments, your roadmap had to be ready yesterday. If your product still ships only classical algorithms, January 2027 is when those products become unsellable in this market.

### February 2026 — Akamai's hybrid PQ TLS becomes default

In **September 2025**, Akamai deployed hybrid **ML-KEM + X25519** key exchange as a limited-availability feature on their edge platform. In **February 2026**, they made it default for all customers.

This is the canary you should watch. Akamai handles a meaningful chunk of the world's HTTPS traffic. When their default key exchange becomes hybrid post-quantum, that traffic is post-quantum-protected against the "harvest now, decrypt later" threat for the key-exchange step.

What this means practically: a substantial portion of your TLS traffic to large websites is now hybrid PQ-protected, whether you've done anything or not. The other side of the connection — your client library — needs to support the hybrid mode to negotiate it. Modern Chrome and Firefox versions do. Older clients fall back to classical.

### Mid-2026 — OpenSSL 3.5 ships with native PQ support

**OpenSSL 3.5**, expected in mid-2026, includes full native support for ML-KEM, ML-DSA, and the hybrid TLS modes. This is the moment when PQ stops being an "install an extra provider" exercise and starts being something every OpenSSL-using application gets when it links against a current version.

If you maintain an application that uses OpenSSL, the version bump to 3.5 is the obvious migration trigger. Hybrid PQ key exchange becomes a config flag rather than a build-time decision.

## What "harvest now, decrypt later" actually is

The reason these deadlines aren't waiting for an actual cryptographically relevant quantum computer:

An adversary today can record encrypted TLS sessions and store the ciphertext. When a sufficiently capable quantum computer becomes available — five years from now, ten years, twenty years, eventually — the adversary can run **Shor's algorithm** against the public keys in those recorded sessions, derive the private keys, and decrypt the traffic.

This means: **data you encrypt today with classical cryptography is at risk of being decrypted in the future.** If your data has a long shelf life — diplomatic cables, intellectual property, medical records, identity documents, financial records, anything you'd be unhappy reading on the front page of a newspaper in 2040 — the *current* transmission is the problem.

The defense is to switch to PQ algorithms now. The recorded ciphertext from before the switch is still exposed, but everything from the switch onward is protected.

## What's actually deploying

A short tour of where PQ is showing up in production:

### Web TLS

- **Cloudflare** deployed hybrid PQ for TLS 1.3 in 2023 and has been refining it. By 2026, hybrid PQ is the default for traffic to/from Cloudflare on supporting browsers.
- **Akamai** (covered above) defaulted hybrid in February 2026.
- **Chrome** has shipped hybrid X25519+ML-KEM (then named Kyber768) since late 2024. Firefox followed in early 2025.

### SSH

- **OpenSSH 9.x** ships with hybrid sntrup761+x25519 by default for new key exchanges. The post-quantum half is sntrup761 (NTRU Prime), an alternative to ML-KEM that's well-regarded and was shipping before ML-KEM was finalized. Expect OpenSSH to add ML-KEM as a peer/replacement in 10.x.

### VPNs

- **WireGuard** has experimental PQ extensions but no standard yet.
- **IPsec** has draft RFCs for ML-KEM integration.
- **OpenVPN** support is in development.

### Code signing and software supply chain

- **Sigstore** is working on adding PQ signature support; ML-DSA is the obvious target.
- **TUF** has a path for PQ signatures.
- Major Linux distributions are tracking the work but haven't committed to PQ-signed repository metadata yet.

### Identity and authentication

- **FIDO Alliance** is working on PQ extensions for WebAuthn / passkeys. See [Passkeys: How They Actually Work]({{< ref "passkeys-how-they-actually-work" >}}) for the current model.
- **OIDC** (OpenID Connect) JWTs will gain ML-DSA signing options as JOSE registrations finalize.

## What to actually do this year

Concrete, prioritized:

### 1. Inventory your cryptography

You can't migrate what you can't see. Build a cryptographic inventory. Start with:

- TLS configurations on every external-facing service.
- TLS configurations on every internal service.
- Code signing certificates and the systems that use them.
- VPN and SSH key exchange parameters.
- Document and email signing flows.
- JWT signing keys.
- Hardware tokens and HSMs (their algorithm support is the bottleneck for everything else).

Frameworks like **PQCryptography Inventory** templates from NIST CSRC are a reasonable starting point.

### 2. Identify your highest-priority migration targets

Two filters:

- **Long-lived data confidentiality.** Anything encrypted in transit today that you care about in 10+ years.
- **Long-lived signing keys.** Anything whose signature you'd be embarrassed to have forged in 5+ years — code-signing certs, document signing, long-lived JWT keys.

These are the things that should migrate first because the cost of failing to migrate them is the largest.

### 3. Test hybrid PQ in TLS

If you operate web infrastructure, test that your stack negotiates hybrid PQ correctly. Most modern reverse proxies (nginx with OpenSSL 3.5, Caddy with the right build, Cloudflare-fronted everything) handle this. Verify in your environment. Wireshark a TLS handshake and confirm the hybrid named group is being negotiated.

### 4. Plan the HSM and PKI migration

This is the hard one. Hardware security modules and certificate authorities have their own upgrade paths. Most vendors have PQ-capable products available now; some have firmware-upgradeable PQ support. The procurement timeline for replacement is real, especially for FIPS 140-3 validated devices, which are a smaller subset than 140-2 was.

### 5. If you ship libraries or products, expose PQ as a customer-visible feature

Customers in regulated industries are starting to ask. Don't wait for them to ask the question; have the answer.

### 6. Don't run PQ-only yet

The standards are new. Library implementations are newer. **Hybrid PQ is the right deployment posture** until the algorithms have been deployed at scale for a few more years. A weakness discovered in ML-KEM or ML-DSA tomorrow doesn't crash the connection; the classical half still holds.

## What I'd watch out for

- **Library quality variance.** Implementations of ML-KEM and ML-DSA are still consolidating. Use vendor-blessed crypto libraries; don't roll your own.
- **HSM lock-in.** Be careful about hardware that supports PQ algorithms only via vendor-proprietary firmware that doesn't match the NIST standards exactly.
- **The "switched to PQ, we're done" trap.** PQ migration is a process, not a switch. Plan for the next round of standards (HQC, future signature schemes, PQ MACs) too.
- **Performance gotchas.** ML-DSA signatures and ML-KEM ciphertexts are bigger than their classical equivalents. Most environments don't care; some do (constrained devices, high-throughput TLS at the edge with tight per-handshake budgets).
- **Compliance vs security.** A configuration can be "FIPS 140-3 with PQ" and still be misconfigured. The migration is necessary but not sufficient.

## What this looks like in 18 months

Reasonable forecast:

- **Hybrid PQ becomes the default** for TLS to the major CDNs and to government endpoints.
- **FIPS 140-3 PQ-capable HSMs** become the procurement default for government and adjacent buyers.
- **Code signing infrastructure** is the long pole; expect ML-DSA code signing to ship in major distributions in 2027, not 2026.
- **The first PQ-related zero-day** in a deployed library — probably a memory-safety bug in a side-channel-vulnerable implementation, not a break of the underlying math. Plan for it; this is what happens to every new cryptographic deployment.
- **Continued migration friction** in legacy systems whose vendors no longer exist or have abandoned the products.

## The bottom line

PQC migration is not a future problem. It is a 2026-2027 problem with regulatory teeth, a deployment story already in motion at major CDNs, and standards that practitioners can actually adopt now. The work to inventory your cryptography, prioritize your migration, and deploy hybrid PQ where you control the stack is work that pays off whether your organization sells to federal customers or not.

The harvest-now-decrypt-later threat means *today's* recorded traffic is the data at risk. The migration starts now.

## Related on this site

- [Passkeys: How They Actually Work]({{< ref "passkeys-how-they-actually-work" >}})
- [What DNS Actually Does]({{< ref "what-dns-actually-does" >}})
- [Web Security](/education/web-security/)

## Sources

- [Post-Quantum Cryptography — NIST CSRC](https://csrc.nist.gov/projects/post-quantum-cryptography)
- [NIST Releases First 3 Finalized Post-Quantum Encryption Standards — NIST](https://www.nist.gov/news-events/news/2024/08/nist-releases-first-3-finalized-post-quantum-encryption-standards)
- [A Complete Guide to Post-Quantum Cryptography Standards — Palo Alto Networks](https://www.paloaltonetworks.com/cyberpedia/pqc-standards)
- [Post-Quantum Cryptography Authentication Migration Guide 2026 — Gupta Deepak](https://guptadeepak.com/post-quantum-cryptography-for-authentication-the-enterprise-migration-guide-2026/)
- [Post-Quantum Cryptography Timeline & Mandates — AxelSpire](https://axelspire.com/business/pqc-timeline-mandates/)
- [Post-Quantum Cryptography 2026: NIST Standards, Migration, Race Against Q-Day — Programming Helper Tech](https://www.programming-helper.com/tech/post-quantum-cryptography-2026-nist-standards-migration)
- [Post-Quantum Cryptography: A Practical Migration Guide for 2026 — TurboGeek](https://www.turbogeek.co.uk/post-quantum-cryptography-migration-2026/)
- [Decoding NIST PQC Standards — Encryption Consulting](https://www.encryptionconsulting.com/decoding-nist-pqc-standards/)
- [Post-Quantum Cryptography Compliance Deadlines — SoftwareSeni](https://www.softwareseni.com/post-quantum-cryptography-compliance-deadlines-and-what-the-global-regulatory-mandates-require/)
- [Post-Quantum Cryptography for Developers — Abhishek Gautam](https://www.abhs.in/blog/post-quantum-cryptography-developers-nist-pqc-migration-2026)
