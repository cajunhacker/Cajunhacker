---
title: "What DNS Actually Does"
date: 2026-05-14
draft: false
tags: ["dns", "networking", "fundamentals"]
categories: ["Cybersecurity", "Infrastructure"]
summary: "DNS is not just \"the phonebook of the internet.\" It's a distributed, cached, hierarchical lookup system — and understanding the hierarchy explains most of what makes DNS work, fail, and get attacked."
---

You probably already know DNS turns `cajunhacker.xyz` into an IP address. That description is true but it leaves out everything interesting. The interesting parts are *who* answers, *in what order*, and *how the answers get cached*.

## The hierarchy

DNS is a tree. Reading a name from right to left:

```
www.cajunhacker.xyz.
                  ^ root (the trailing dot)
            ^ TLD: .xyz
 ^ second-level: cajunhacker
^ subdomain: www
```

Each level is owned by a different authority:

- **Root servers** know which servers are authoritative for each TLD (`.com`, `.xyz`, `.io`, etc.).
- **TLD servers** know which servers are authoritative for each domain registered under them.
- **Authoritative nameservers** for `cajunhacker.xyz` know the actual records (A, AAAA, CNAME, MX, TXT, etc.).

A lookup walks this tree until it gets an answer.

## A real query, step by step

When your laptop wants `www.cajunhacker.xyz`:

1. The OS asks its **stub resolver** (built into your operating system).
2. The stub resolver asks its configured **recursive resolver** — usually your ISP, or `1.1.1.1`, `8.8.8.8`, or whatever you set.
3. The recursive resolver, if it doesn't have the answer cached, asks a **root server**: "who handles `.xyz`?"
4. Root responds with the `.xyz` nameservers.
5. The recursive resolver asks a `.xyz` nameserver: "who handles `cajunhacker.xyz`?"
6. `.xyz` responds with the authoritative nameservers for the domain.
7. The recursive resolver asks one of those: "what's the A record for `www.cajunhacker.xyz`?"
8. It gets an answer, caches it for the TTL, and returns it to your stub.
9. Your stub returns it to the application.

That's seven network round-trips for a "cold" lookup. The reason DNS feels instant in practice is **caching**: at every layer, answers are stored for the duration of their TTL.

## Records you'll actually see

- **A** — name to IPv4 address
- **AAAA** — name to IPv6 address
- **CNAME** — alias from one name to another (cannot coexist with other records at the same name; cannot be at the apex)
- **MX** — where mail for this domain should go
- **TXT** — arbitrary text, used for SPF, DKIM, DMARC, domain ownership proofs
- **NS** — which nameservers are authoritative for a zone
- **SOA** — administrative metadata for the zone
- **CAA** — which certificate authorities are allowed to issue certs for this name

## Things that bite people

**TTL surprises.** If you change a record but its TTL was 24 hours, the old value can be cached at resolvers around the world for up to 24 hours. Lower the TTL *before* you make the change, not when you make it.

**The apex / CNAME problem.** You cannot put a CNAME at `cajunhacker.xyz` (only at `www.cajunhacker.xyz` or other subdomains). Many DNS providers offer "ALIAS" or "ANAME" records to work around this — they're just CNAMEs the provider resolves for you at query time.

**Negative caching.** Resolvers cache the absence of a record too. If you ask for a record that doesn't exist, get an NXDOMAIN, then create the record, the resolver may keep saying "no" until the negative TTL expires.

**Split-horizon DNS.** Internal and external resolvers can return different answers for the same name. This is a feature, but it makes troubleshooting harder if you forget which view you're in.

## Where security comes in

DNS is unauthenticated by default. The query and response are plaintext UDP. Three things mitigate this:

- **DNSSEC** — cryptographic signatures on records. Detects tampering between authoritative servers and resolvers. Doesn't encrypt; doesn't protect the last-mile resolver-to-stub link.
- **DoH / DoT** — DNS over HTTPS / TLS. Encrypts the last-mile link between your stub and your recursive resolver. Doesn't replace DNSSEC.
- **CAA records** — tell the world which CAs are allowed to issue certificates for your domain. Reduces blast radius if some CA gets popped.

Attacks worth knowing the names of:

- **Cache poisoning** — convincing a resolver to cache a wrong answer
- **NXDOMAIN hijacking** — ISPs returning "search results" for typos
- **Subdomain takeover** — a CNAME pointing at a service you no longer own; the attacker registers the dangling target and now controls a subdomain of yours
- **DNS tunneling** — exfiltrating data via crafted DNS queries

## Tools to learn

```bash
dig www.cajunhacker.xyz          # full lookup with detail
dig +trace www.cajunhacker.xyz   # walk the hierarchy yourself
dig +short MX example.com        # just the answer
dig @1.1.1.1 example.com         # ask a specific resolver
host -a example.com              # quick summary
nslookup example.com             # works on Windows too
```

`dig +trace` in particular is worth running once on a domain you own — watching the query actually walk from root to TLD to authoritative is the moment "the hierarchy" stops being an abstraction.

## The bottom line

DNS is a cache-heavy, hierarchical, distributed system. Most weird DNS bugs are really cache or TTL bugs in disguise. Most DNS attacks exploit the fact that the protocol was designed in 1983 and trusts everyone. Knowing the hierarchy gives you a map for both.
