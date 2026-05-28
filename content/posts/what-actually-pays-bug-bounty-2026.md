---
title: "What Actually Pays in Bug Bounty in 2026"
date: 2026-05-06
draft: false
tags: ["bug-bounty", "hackerone", "bugcrowd", "synack", "immunefi", "idor", "broken-access-control", "ai-security", "smart-contracts"]
categories: ["Bug Bounty"]
summary: "AI-in-scope programs are up 270%, broken access control critical bugs are up 36%, and Microsoft paid out $1.6M in a single focused event. A look at what the bug bounty market is actually rewarding right now, and what to focus on if you're hunting today."
---

If you are hunting bugs in 2026 the same way you hunted in 2022, you are leaving money on the table. The bug classes that pay have shifted. The platforms have repositioned. And the single biggest growth area on every major platform is one that did not meaningfully exist three years ago: AI systems.

This post is a tour of where the rewards are flowing in 2026, based on platform reports, public payouts, and the kinds of finds that are clearing triage.

## Platform landscape

The four platforms that actually matter for English-language hunters:

### HackerOne — roughly 38% of practitioner mind share

The breadth platform. The most public programs, the most variety, the most opportunity for new hunters to find their first paid bug. Payouts scale from ~$500 for mid-severity findings to $50,000+ for criticals at top programs.

The 2026 datapoint that matters: **HackerOne's annual reporting shows programs with AI in scope grew 270%**. That is not a typo. AI features are the fastest-growing target surface on the platform.

Microsoft's **Zero Day Quest** event in 2025 paid out **over $1.6 million in a single focused push** for cloud and AI vulnerabilities. Microsoft has run similar focused events since. Watch for them — focused events compress competition and raise per-bug payouts.

### Bugcrowd — ~32% market share

Comparable program portfolio to HackerOne with different relative strengths. Average accepted-report payouts $300-$3,000, top payouts $50,000+. The 2026 trend lines from Bugcrowd's own reporting:

- **Broken access control critical bugs: +36%**
- **API vulnerabilities: +10%**
- **Network vulnerabilities: 2x**
- **Hardware vulnerabilities: +88%**

Hardware doubling-and-then-some is the surprise. IoT, automotive, and consumer hardware programs have grown, and the average payout per critical there is healthy because the disclosed bug count is still relatively small.

### Synack — invite-only, vetted researcher pool

The "we screened you" platform. Smaller researcher pool, narrower in scope, much higher average payouts: **$2,000-$10,000 average**, **$100,000+ at the top end**. If you've built a track record, the application is worth filing.

### Immunefi — Web3 / DeFi / smart contracts

Dominates the blockchain bounty space. **Critical smart-contract bugs regularly reach six- or seven-figure payouts** — the rewards are calibrated to the actual financial risk of the exploit, and that's millions of dollars in many cases. The flip side is that the bar is high, the targets are unforgiving, and a wrong-track week is a wrong-track week.

Hunters with Solidity or Move expertise are well-positioned. Hunters without either should plan a year of skilling up before expecting payouts.

## What's actually paying

### 1. Broken access control / IDOR / authorization flaws

The headline finding across every platform's data: **authorization bugs are climbing, commodity injection bugs are declining**.

XSS and SQLi are not dead. They still pay. But the *easy* ones have been swept by automated testing and pre-deploy scanners. The ones that survive into production tend to be:

- Stored XSS in less-trafficked parts of an app
- Second-order SQLi that requires unusual data flow
- Edge-case template injection in newer frameworks

Meanwhile, **IDOR remains everywhere**. Every app with user objects has authorization decisions per endpoint. Every endpoint has an integer or UUID that can be replaced. Every "is this user allowed to see this?" check is a place where the answer might be wrong, especially under permission changes, role transitions, or feature flags.

Concrete things that have been paying:

- **Cross-tenant data exposure** in multi-tenant SaaS. Replace `tenant_id` in the URL or body and see what comes back.
- **Permission bypass via API endpoints that the UI doesn't use.** The web app's UI hides the admin button; the API endpoint behind it doesn't check the role.
- **GraphQL field-level authorization mistakes.** The resolver checks the parent type but not the field.
- **Forced browsing to admin endpoints**, especially admin endpoints on subdomains that nobody is monitoring.
- **Permission drift after object ownership changes.** Transferring an object between users sometimes leaves stale ACLs that grant access neither user expects.

### 2. AI features

This is the gold rush. Every major program is adding AI assistants, RAG flows, image-gen features, agent loops, and autonomous tool-use to their products faster than their security teams can model the new attack surfaces.

The bug classes that are clearing triage on AI features:

- **Prompt injection that produces real authority change**, not just "the chatbot said a rude thing." If you can make an AI assistant exfiltrate data, take actions the user didn't approve, or escalate through a tool-use loop, that's a real bug.
- **Data leakage via context windows.** AI features that load a user's data into the context sometimes serve up *other* users' data because of cache or context-stitching bugs.
- **Indirect prompt injection via documents, emails, web pages, or any content the AI processes.** When a customer's CRM notes can re-program their support bot, that's a vulnerability.
- **RAG store poisoning.** The AI cites a document that an attacker controls because the RAG ingestion process didn't validate sources.
- **Tool-use authorization bugs.** The AI can call a tool. Did the system verify the user is allowed to call the tool, or just that the AI was?
- **Plugin / connector access bypass.** Third-party integrations into AI products have authorization layers, and those layers have bugs.

If you've done web app testing, this is mostly web app testing with new vocabulary. Don't be intimidated by the framing.

### 3. Subdomain takeovers and dangling DNS

Still happening. Still paying. The 2026 version is more about cloud resources than the classic GitHub Pages or Heroku dangling CNAME — although those still appear. Look at:

- S3 buckets, Azure blob, GCS buckets named in CNAME or used in image/asset URLs.
- Vercel, Netlify, Fly.io and other PaaS targets where the customer left a CNAME after migration.
- Cloudfront and CloudFlare R2 names.
- Old marketing campaign subdomains that pointed at vendor SaaS that the company no longer uses.

The win is the same as it always was: register the dangling target, serve content under the victim's domain, abuse cookies/SSO/redirect/marketing trust.

### 4. SSRF, especially cloud metadata

Server-side request forgery has been a top-tier class for years and keeps producing because cloud metadata services are too easy to reach from too many places. If you can make a server fetch a URL of your choosing, you're often one hop from credentials.

2026 specific notes:

- AWS IMDSv2 adoption is finally widespread, which makes naive SSRF-to-metadata harder. The bugs that survive are typically multi-step: SSRF + header injection, SSRF + redirect, SSRF via a proxy header the app passes through.
- Azure and GCP metadata services have their own quirks worth knowing in detail.
- Internal services exposed on `localhost` or on a private IP from a hosted service are a frequent finding.

### 5. Authentication and session bugs

Per the trend data, **authentication failures are climbing**. The specific bugs that have been paying:

- Username enumeration via response timing or message variance — still surprisingly common.
- Password reset flows that leak the reset token or fail to invalidate sessions.
- JWT misconfigurations: `alg=none` is gone, but `kid` injection, weak signing keys, missing audience checks, and token reuse across services are alive and well.
- OAuth state and redirect_uri issues — easier to find than you'd guess on programs that have evolved their OAuth surface over years.
- Multi-factor bypasses, including "remember this device" flows that don't actually bind to a device, and step-up auth flows that can be skipped via the API.

## Recon and tooling, briefly

You don't need an expensive stack. You need a focused one. The 2026 baseline:

- **Burp Suite** (Community for learning; Pro if you're hunting seriously). Still the standard.
- **httpx, subfinder, amass** for fast asset discovery.
- **ffuf or feroxbuster** for content/parameter discovery.
- **nuclei** for known-vuln sweeps across newly discovered assets. Useful for breadth, not where the depth bugs live.
- **A note-taking system** that you actually use. Obsidian, Logseq, plain Markdown, your call.

The tool that matters most is the one between your ears, paired with the discipline to focus on one feature class for an entire session rather than spraying.

## How to actually start (or restart) hunting in 2026

1. **Pick one platform, one program, one feature class.** Don't sample. Spend 20 hours in one place before you judge it.
2. **Make AI features a deliberate part of your study.** Read OWASP's LLM Top 10. Read public AI bug reports. Practice on programs with AI in scope — they're less crowded than the classic surfaces.
3. **Read disclosed reports daily.** HackerOne's hacktivity feed is free education. Pentester Land's weekly newsletter is the curated version.
4. **Write up everything you find, even when the report gets closed.** Your writing improves your hunting; your writing also gets you noticed.
5. **Time-box.** A six-hour session on the wrong target is six hours of wrong target. Set checkpoints.

## What this looks like in a year

Reasonable predictions for the 12-18 month window:

- **AI-in-scope programs reach mainstream.** What's a 270% growth bucket in 2026 will be a default category in 2027.
- **More hardware programs**, especially for AI-adjacent devices (home AI hardware, smart-home hubs, automotive).
- **More invite-only and time-boxed events** at the high end. The Zero Day Quest model works; expect copies.
- **Smart-contract payouts stay enormous** but require more specialization. Generalist web hunters will probably stay out.
- **Continued decline of XSS/SQLi as a primary income source**, with the exception of hunters who specialize in complex injection chains.

## The bottom line

The bug bounty market is bigger than it has ever been, and the bug classes it rewards are shifting toward authorization, AI features, and high-impact infrastructure. The hunters who track those shifts and put their hours where the rewards are flowing — rather than where the rewards used to be — are the ones turning bounty into real income.

## Related on this site

- [Web Security](/education/web-security/) — the floor; this post assumes you have it
- [Bug Bounty Workflow](/projects/bug-bounty-workflow/) — how I structure recon, triage, and reporting

## Sources

- [The Best Bug Bounty Websites in 2026: A Researcher's Guide — Training Camp](https://trainingcamp.com/articles/the-best-bug-bounty-websites-in-2026-a-researchers-guide-to-hackerone-bugcrowd-and-beyond/)
- [Highest Paying Bug Bounty Platforms (2026 Guide) — Technary](https://www.technary.com/software/highest-paying-bug-bounty-platforms-2026-guide/)
- [Top 5 Bug Bounty Platforms for Security Researchers in 2026 — Gupta Deepak](https://guptadeepak.com/top-5-bug-bounty-platforms-for-security-researchers-in-2026/)
- [Smart Contract Bug Bounties Statistics 2026 — SQ Magazine](https://sqmagazine.co.uk/smart-contract-bug-bounties-statistics/)
- [Top 10 Best Bug Bounty Platforms in 2026 — GBHackers](https://gbhackers.com/best-bug-bounty-platforms/)
- [Bug Bounty Hunting in 2026 — DEV Community](https://dev.to/krlz/bug-bounty-hunting-guide-2026-from-zero-to-paid-security-researcher-5c82)
