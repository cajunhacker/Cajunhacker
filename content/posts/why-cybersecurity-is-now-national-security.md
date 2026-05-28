---
title: "Why Cybersecurity Is Now National Security"
date: 2026-05-10
draft: false
tags: ["policy", "regulation", "national-security", "sec", "circia", "nis2"]
categories: ["Political Cybersecurity", "Cybersecurity"]
summary: "The last five years quietly moved cybersecurity from an IT line item to a national-security topic on three continents. A short tour of the regulations that made it happen and what they mean for practitioners."
---

For most of the last thirty years, "cybersecurity" was an IT problem. Budgets came from IT. Reporting went to IT. Outcomes were measured in uptime. Sometime around 2020, that quietly stopped being true on three continents. This post is the short version of what changed and what it means.

I'm intentionally going to keep this non-partisan. The shift I'm describing is happening across administrations and across parties on both sides of the Atlantic. If you read this looking for a culture-war angle, you'll be disappointed — the changes are mostly being made by career civil servants and regulators, not headline politicians.

## What changed

Three pressures stacked at once:

1. **Ransomware stopped being annoying and started being societal.** Hospital networks went dark. Fuel pipelines stopped pumping. Schools cancelled classes. Insurers reclassified the risk. The people writing policy noticed.
2. **Nation-state operations moved from "spy stuff" to "they're in everyone's networks."** SolarWinds, Microsoft Exchange (ProxyShell / ProxyLogon), MOVEit, the Volt Typhoon disclosures. The line between espionage and pre-positioning blurred.
3. **The financial system got loud about it.** Insurance markets repriced cyber risk, sometimes pulling coverage entirely. Boards started getting personally named in shareholder suits.

The combined result: cybersecurity is now regulated infrastructure in the way that aviation, banking, and power generation are.

## The regulations that actually matter

### United States — SEC cybersecurity disclosure rules

Effective late 2023, public companies must:

- Disclose material cybersecurity incidents on Form 8-K within four business days of determining materiality.
- Annually disclose their cybersecurity risk management, strategy, and governance in Form 10-K.

The four-day clock is the part that has fundamentally changed how incidents are handled. There is no longer time to "investigate and decide later" — the company must reach a materiality determination quickly, document it, and disclose. That requires pre-built playbooks, named decision-makers, and counsel on speed-dial.

### United States — CIRCIA (Cyber Incident Reporting for Critical Infrastructure Act)

CIRCIA requires operators of "covered critical infrastructure" to report substantial cyber incidents to CISA within 72 hours, and ransomware payments within 24 hours. The implementing regulations rolled out through 2024–2025. The list of "covered" sectors is broad — well beyond what most people picture as critical infrastructure.

### European Union — NIS2

NIS2 went into force across EU member states in 2024. It expands the original NIS Directive substantially:

- Many more sectors are in scope ("essential" and "important" entities).
- Management-level personal liability for security failures.
- Mandatory incident notification on a graduated timeline (early warning within 24 hours, incident notification within 72 hours).
- Supply chain security explicitly required.

### European Union — DORA (Digital Operational Resilience Act)

For financial entities, DORA went into force in January 2025. It governs ICT risk management, incident reporting, resilience testing, and — uniquely — third-party ICT provider oversight, including direct EU oversight of "critical" providers regardless of where they're headquartered.

### European Union — Cyber Resilience Act (CRA)

CRA is the EU's product-side rule: products with digital elements (hardware *and* software) sold into the EU must meet baseline cybersecurity requirements, support security updates for defined periods, and report actively exploited vulnerabilities. Full applicability lands in 2027.

### United Kingdom

The UK has its own version of NIS regulations and an emerging Cyber Security and Resilience Bill that expands scope along similar lines to NIS2.

### Beyond Europe and the US

- **Australia:** Critical Infrastructure Act amendments, mandatory incident reporting, expanded government step-in powers.
- **India:** CERT-In's 2022 directions on incident reporting (six-hour clock for many incidents).
- **Japan and Singapore:** sector-specific cybersecurity requirements with increasing teeth.

## What this means in practice

### For executives

- Cybersecurity decisions now carry **personal regulatory risk** in multiple jurisdictions. NIS2 in particular targets management.
- "We outsourced it to the vendor" is no longer a sufficient answer in most regimes.
- Materiality determinations on incidents need a pre-agreed process. Don't draft it during the incident.

### For security teams

- **Detection and response telemetry is mandatory**, not optional. You cannot make a materiality determination in four days if your logs are five days deep.
- **Reporting templates and channels** to relevant regulators should be drafted and tested *before* an incident.
- **Vendor and supply chain inventories** must be real and current. NIS2 and DORA both look at this. So does CRA on the product side.
- **Incident classification and severity definitions** need to map to regulatory thresholds. "Severity 3" in your internal ticketing system needs to be translatable to "substantial incident" under CIRCIA, "significant incident" under NIS2, and so on.

### For practitioners getting into the field

The job market is changing in two directions at once:

- **Compliance and GRC roles** are growing fast and paying well, because the regulations create demand the market can't fill quickly.
- **Defensive engineering** (detection, response, forensics) is getting more leverage because regulators care about what was logged, what was alerted, and how fast it was responded to.

If you're considering specialization, this is a tailwind for both blue-team and risk/governance careers.

## What this doesn't mean

- It doesn't mean compliance equals security. A company can be NIS2-compliant and still owned by Tuesday. The regulations are a floor.
- It doesn't mean attackers are intimidated by paperwork. They aren't.
- It doesn't mean small organizations are off the hook. Many of the "important entity" thresholds catch organizations far smaller than people expect.

## The bottom line

Cybersecurity is now treated by Western governments the same way they treat aviation safety, financial soundness, and food supply: as critical infrastructure with mandatory reporting, named accountable persons, and real penalties.

For practitioners, this is good news. The work matters more, gets resourced better, and reports higher. The trade-off is that it's also less forgiving — what used to be a hard week is now a regulatory filing on a clock.

## Further reading

- The actual texts of NIS2, DORA, CRA, CIRCIA, and the SEC rule are not as painful to read as you'd think. The summaries are often worse than the originals.
- [What DNS Actually Does]({{< ref "what-dns-actually-does" >}}) — a much smaller topic, but the same principle: read the primary sources.
