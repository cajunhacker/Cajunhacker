---
title: "Web Security"
date: 2026-05-16
description: "The OWASP Top 10 as working knowledge — how each class of bug actually manifests, how to find it, and how to prevent it."
weight: 40
---

Web is the largest attack surface most organizations have. You don't need to be a developer to find web bugs, but you do need to understand HTTP, how applications use it, and the recurring classes of mistake. This page is the floor.

## The protocol layer

Before vulnerabilities, you need to know:

- **HTTP methods.** GET, POST, PUT, PATCH, DELETE, OPTIONS, HEAD. What is meant to be safe vs. idempotent vs. neither.
- **Status codes.** 2xx success, 3xx redirect, 4xx client error, 5xx server error. The interesting ones for security: 401 vs 403, 200 with an error body, 302 with sensitive data in the URL.
- **Headers that matter for security.** `Content-Security-Policy`, `Strict-Transport-Security`, `X-Content-Type-Options`, `X-Frame-Options` / `frame-ancestors`, `Referrer-Policy`, `Set-Cookie` flags (`HttpOnly`, `Secure`, `SameSite`).
- **Cookies vs tokens.** Where each lives, what protects each, and where each leaks.
- **CORS.** What it is, what it isn't (it is not a security control on the server — it's a browser policy).
- **TLS basics.** Certificates, handshake, why "HTTPS" is necessary but not sufficient.

## The OWASP Top 10 — what each really means

**Broken Access Control.** The most common class of bug today. The server doesn't check that the user is allowed to do the thing they're trying to do. IDOR (`/api/orders/12345` where you change the number), missing role checks, forced browsing to admin endpoints. Find by changing identifiers in URLs and request bodies and seeing what comes back.

**Cryptographic Failures.** Sensitive data in URLs, plaintext fields, weak ciphers, hard-coded keys, secrets in JavaScript bundles, missing TLS on internal hops.

**Injection.** SQL injection is the famous one, but it's the whole family: command injection, LDAP injection, NoSQL injection, server-side template injection. The pattern: user input is concatenated into a query/command/template without proper separation.

**Insecure Design.** Architecture-level mistakes — features that *can't* be made safe regardless of implementation. Password reset that emails the actual password. Rate limits that only apply per-session.

**Security Misconfiguration.** Default credentials. Verbose error pages in production. Open S3 buckets. Debug interfaces on the internet. Unpatched components. The largest "vulnerabilities" by count are configuration mistakes.

**Vulnerable and Outdated Components.** Old libraries, old frameworks, abandoned plugins. The fix is patching, not heroics.

**Identification and Authentication Failures.** Username enumeration, weak password policies, no MFA, session fixation, predictable session IDs, JWT misconfigurations.

**Software and Data Integrity Failures.** Auto-updates without signature verification. Trusting a CDN you don't control for security-critical JS. Insecure deserialization.

**Security Logging and Monitoring Failures.** No logs. Logs that nobody reads. Logs that the application itself can write into (so attackers can erase their tracks).

**Server-Side Request Forgery (SSRF).** App fetches a URL the user controls. Attacker points it at `169.254.169.254` (cloud metadata) or internal services. Major cloud breaches have started here.

## How to actually learn this

1. **Portswigger Web Security Academy** is free, comprehensive, and structured around the bug classes above. Work through it.
2. **Burp Suite Community** is the right tool. Learn the proxy, repeater, decoder, and intruder.
3. **Set up DVWA or Juice Shop** locally and exploit each vulnerability category yourself.
4. **Read real bug bounty disclosures.** HackerOne's hacktivity and disclosed reports teach you what real-world findings look like — they rarely look like textbook examples.

## What I'd watch out for as a defender

- **Don't trust the client for authorization decisions.** Ever.
- **Encode output for the right context.** HTML-safe ≠ JS-safe ≠ URL-safe ≠ SQL-safe.
- **Use parameterized queries.** Always. There is no good excuse for string-concatenation SQL in 2026.
- **Log enough to investigate.** Source IP, user ID, action, timestamp, request ID — every action.
- **Watch your secrets.** `git-secrets`, secret scanning in CI, a vault for production secrets.

## What's next

- [Networking](/education/networking/) — the layer beneath web
- [Bug Bounty Workflow](/projects/bug-bounty-workflow/) — applying this in the field
- [Training Platforms](/resources/training-platforms/)
