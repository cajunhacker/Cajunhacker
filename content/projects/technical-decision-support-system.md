---
title: "Technical Decision Support System"
date: 2026-05-16
description: "Structured decision aids for IT and security choices — making tradeoffs explicit and reproducible."
weight: 50
---

A lot of cybersecurity and IT decisions are made on vibes. "We picked vendor X because the rep was responsive." "We use framework Y because someone on the team likes it." This is fine for small choices and corrosive at scale.

The Technical Decision Support System (TDSS) is my attempt to apply a lightweight, structured decision-making approach to recurring IT and security choices — for myself, and (down the road) potentially as a reusable tool.

## What it is

A small, opinionated workflow that turns a technical decision into a written artifact with:

- **The decision statement.** One sentence. What is being decided.
- **Context.** Why now. What's driving this.
- **Constraints.** Hard ones (budget, compliance, must-integrate-with-X) vs soft ones (team familiarity, vendor stability).
- **Options under consideration.** Each named, briefly described, with sources.
- **Evaluation criteria.** Weighted if the decision warrants it.
- **Scoring.** Per option, per criterion. Brief justifications, not numbers in a vacuum.
- **Risks and tradeoffs.** Explicit. The thing the chosen option is *worse* at than the alternatives.
- **The decision.** What was chosen.
- **Review trigger.** When this should be re-examined — a date, a milestone, or a condition.

## Why this matters in security

- **Auditable.** When the next person asks "why are we using this SIEM?", the answer isn't lost.
- **Cumulative.** Decisions compound. Documenting the chain means future decisions can reference past ones.
- **Honest.** Forcing yourself to write the tradeoffs catches reasoning that wouldn't survive contact with prose.
- **Faster the next time.** A library of past decisions is its own asset.

## Current state

Personal use, in active development. The artifact format is settling. A small CLI or web tool to make creating one painless is on the roadmap.

## What it is not

- Not a substitute for judgment. The framework helps; it doesn't decide.
- Not a vendor-evaluation matrix template. Those exist and they're fine.
- Not an attempt to make decisions sound scientific. Most technical decisions are partly aesthetic. Naming that is more honest than pretending otherwise.

## Linked posts

- [My Cybersecurity Learning Path]({{< ref "my-cybersecurity-learning-path" >}})

## Status

In development. The pattern is being used; the tooling is being built.
