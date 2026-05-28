---
title: "Bug Bounty Workflow"
date: 2026-05-16
description: "How I structure recon, triage, and reporting for bug bounty work."
weight: 40
---

Bug bounty hunting at any scale beyond "occasionally pop a target" needs a workflow. Otherwise you re-do recon you already did, lose notes on findings you couldn't quite reproduce, and end up writing reports that get closed informative because they read like a transcript.

This page is the shape I follow. It's not original — most serious hunters arrive at something similar.

## Phases

### 1. Program selection

- Read the policy carefully. **Scope, out-of-scope, severity, payouts, response SLAs.** Out-of-scope items will eat your time if you miss them.
- Look for programs where you have a real asymmetric advantage — a tech stack you know well, a feature class others ignore, a language barrier you can cross.
- Avoid programs with stale dashboards. Hunting on a target with two-year response times is a slow way to lose motivation.

### 2. Recon

- Subdomains via passive sources first (crt.sh, certificate transparency, public datasets) before active enumeration.
- Map the application surface: hostnames, technologies, APIs, mobile endpoints, third-party integrations.
- Note version banners and tech fingerprints, but treat them as hints, not findings.
- All output goes into a single per-program directory with a consistent layout.

### 3. Bug hunting

- Pick a feature class for the session and stick to it (auth flows, file uploads, IDOR on a specific endpoint family, SSRF surfaces). Context-switching kills depth.
- Burp Suite for HTTP, ffuf or feroxbuster for content discovery, custom scripts for anything repetitive.
- Notes go into a markdown file per target, with timestamps and request/response snippets for anything that looked off, even if I didn't pursue it.

### 4. Triage

Before reporting, I ask:

- **Can I reproduce it cleanly** from a fresh session, in a clean browser, with no tooling-specific weirdness?
- **What's the real impact?** Not the theoretical maximum — the realistic outcome a normal user could experience.
- **Is it in scope?** Re-check the policy.
- **Is it a known issue?** Check the program's previous disclosures.

### 5. Reporting

- One title line that names the bug class and the affected feature.
- A short summary an L1 triager can understand in fifteen seconds.
- A clear, minimal reproduction. Every step. Cleaned-up requests, not raw Burp exports.
- Impact stated in business terms, not buzzwords.
- Suggested remediation. Specific. Not "use parameterized queries" generically — tell them which query, which file, which input.

### 6. Aftercare

- Respond to triage questions promptly and politely.
- If the report is closed, ask once for clarification on why. Move on if the answer isn't useful.
- Disclose only when the program permits or the bug is fixed and they're OK with it.

## Tools

- **Burp Suite Community / Pro** — proxy, repeater, intruder. Worth Pro if you do this seriously.
- **ffuf / feroxbuster** — content and parameter discovery.
- **nuclei** — known-vulnerability templates. Useful for scope-wide sweeps, not deep work.
- **subfinder / amass** — subdomain enumeration.
- **httpx** — quick liveness and tech fingerprinting at scale.
- **A note system you actually use** — Obsidian, Logseq, plain Markdown, whatever sticks.

## What I'd watch out for

- **Scope creep.** "Just a quick check" on an out-of-scope asset is how you get banned.
- **Aggressive scanning.** Crank down concurrency. You are not the only hunter on the program.
- **Reporting noise.** Low-quality reports hurt your reputation with triagers; reputation compounds.
- **Burnout.** Time-box your sessions. A bug bounty habit dies fast under unrealistic targets.

## Linked posts and pages

- [Web Security](/education/web-security/)
- [My Cybersecurity Learning Path]({{< ref "my-cybersecurity-learning-path" >}})

## Status

Active. Workflow refined over time; this page will get updated as the shape changes.
