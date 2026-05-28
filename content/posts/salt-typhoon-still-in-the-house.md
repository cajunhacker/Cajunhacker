---
title: "Salt Typhoon: Still in the House"
date: 2026-05-03
draft: false
tags: ["salt-typhoon", "china", "telecom", "calea", "cisco", "fcc", "national-security", "infrastructure"]
categories: ["Political Cybersecurity"]
summary: "Salt Typhoon hit at least nine major U.S. telecoms by exploiting seven-year-old unpatched Cisco bugs. As of early 2026, the FBI says the threat is 'still very much present.' The FCC repealed the post-incident cyber rules in November 2025. Here's where things actually stand."
---

The Salt Typhoon intrusions are the most consequential cybersecurity story of the decade, and the one that gets the least proportionate coverage relative to its scale. This post is the deep dive — what happened, where the cleanup actually stands, what the regulatory reaction was, and what practitioners should take from it.

I'll keep the policy framing non-partisan. The facts are bad enough on their own.

## What Salt Typhoon is

**Salt Typhoon** is the U.S. government's designation for a China-attributed cyber-espionage campaign that breached the core networks of telecommunications and internet service providers worldwide. The scale, as best public reporting can establish:

- **More than 200 telecommunications and ISP networks globally** are believed compromised.
- **At least nine major U.S. telecoms** confirmed breached — including AT&T, Verizon, and T-Mobile.
- **Tens of millions of phone records stolen**, including those of senior government officials in multiple nations.
- **Targeted intercepts of senior U.S. political figures**, including phone records and calls associated with the 2024 presidential campaigns of both parties.

The U.S. Senate Commerce Committee and CISA have publicly characterized the situation as severe. The FBI Deputy Assistant Director for Cyber, Michael Machtinger, stated at CyberTalks in February 2026 that Salt Typhoon's presence in compromised networks was **"still very much present today."**

That sentence should stop you. It's not a retrospective on a closed incident. It's an active intrusion the government has been unable to fully expel from the U.S. telecommunications backbone.

## How they got in

Investigators found a pattern that is not unique to Salt Typhoon but is its signature for the U.S. telecoms:

- **Legacy equipment not updated in years.** Some core routers had not had configuration changes that addressed known issues in well over half a decade.
- **Router vulnerabilities with patches available for seven years** that were never applied. Specifically, Cisco devices with publicly known vulnerabilities and freely available fixes.
- **Weak credentials.** Some access reportedly came from credentials with passwords that would not survive a casual brute-force.
- **Exploitation of the CALEA wiretap infrastructure.** The government-mandated lawful intercept systems — the same backdoors built to enable U.S. law enforcement — were one of the systems leveraged for access to communications data.

That last point is the part that has driven the most thoughtful policy reflection. **Mandated backdoors don't discriminate between authorized and unauthorized users.** If you build a wiretap interface for the FBI, the same interface eventually becomes useful to Beijing, Moscow, or any actor with sufficient skill to find it. This is not theoretical. Salt Typhoon is the case study.

## What was stolen

Public reporting indicates, at minimum:

- **Call metadata** — who called whom, when, for how long — at scale.
- **Some recorded calls** from targeted individuals.
- **Customer records and PII** from billing and identity systems.
- **Information about U.S. lawful intercept targets** — which is to say, China likely now knows who the FBI is wiretapping.

The third item is the most damaging in intelligence terms. The first two are what gets headlines.

## Where the cleanup stands

This is the part that's hard to write without becoming alarmist. As of early 2026:

- **AT&T and Verizon have not released the security assessments** conducted by Mandiant after the breaches became public.
- **Both companies have declined to fully cooperate** with congressional requests for information about remediation.
- **Telecoms have not publicly demonstrated** that Salt Typhoon has been eradicated from their networks.

The senate committee hearings on this topic in late 2025 and early 2026 produced something rare: bipartisan frustration with the telecom industry. The senators in those hearings were not particularly aligned on much, but on the question of whether the telecoms could prove they had kicked Salt Typhoon out, the answer from both sides of the aisle was: "no."

A practical implication: when major U.S. officials and their staffs talk on standard cellular networks today, the working assumption should be that those conversations may not be private with respect to the Chinese government.

## The regulatory whiplash

The U.S. policy response is its own story, separate from the technical one.

**January 2025:** The FCC under the prior administration adopted new rules requiring telecommunications companies to implement specific cybersecurity protections — including, notably, **mandatory multi-factor authentication** for the kind of admin systems Salt Typhoon exploited.

**November 2025:** The FCC voted **3-2 to repeal** those rules. The case for repeal, as argued by telecom industry trade associations, was that the rules were a "regulatory burden" and that voluntary action was sufficient.

The technical community's reaction was, fairly summarized, *bewildered*. The vote was held against the backdrop of an ongoing intrusion that the government itself was characterizing as still active.

This is the kind of thing that's hard to make sense of without acknowledging that **cybersecurity policy is partly a political process and partly a regulatory-capture process** and not always primarily a technical one. I'm not going to assign motive here; I'll just note the sequence.

## What this looks like internationally

Salt Typhoon is not a U.S.-only story. The 200+ networks figure includes major operators in Europe, Latin America, the Pacific, and elsewhere. Most non-U.S. networks have done less public disclosure than the U.S. carriers — partly because EU disclosure rules under NIS2 give carriers more time and more discretion about public versus regulator-only notifications.

The strategic context is widely reported as positioning for a **possible conflict over Taiwan**. The argument is that pre-positioning in adversary telecommunications and critical infrastructure provides intelligence value in peacetime and disruption value in conflict. Whether the inference is correct is something I'm not going to speculate on; the *intelligence-community judgment* that this is the framing is widely reported.

## What practitioners should take from this

Several things, depending on where you sit.

### If you're in a telecom or carrier-grade network

You probably can't read this honestly without already being uncomfortable. The basic hygiene failures Salt Typhoon exploited — unpatched core routers, weak admin credentials, single-factor access to sensitive systems — are not exotic. They are the kind of thing every internal audit identifies and every operations team finds easier to defer than fix.

If your job is in this space, the practical takeaway is to advocate harder for the boring work. Patch the routers. Roll the credentials. Put MFA on the jump host. Decide which legacy management plane is going to get retired and actually retire it. The political environment may be less supportive of cybersecurity regulation in the near term, but the technical reality is that nation-states are reading your traffic if you don't.

### If you're in policy or government cyber

The case study is right there. The argument against mandated backdoors is now a real-world case, not a hypothetical. The argument for minimum cybersecurity standards in critical infrastructure has empirical support. The argument that voluntary cooperation is sufficient has empirical disproof.

Whether the policy environment moves toward stricter standards, weaker standards, or more of the same, the conversation will be more informed if you read the primary sources rather than the secondary commentary.

### If you're a security practitioner not in critical infrastructure

The takeaway is more sober. **Assume your phone metadata is not private with respect to a major nation-state.** Plan accordingly. For most people, this changes very little — your phone metadata wasn't really private before. For some people — journalists, dissidents, certain professional categories — this changes everything about communication choices.

End-to-end encrypted messaging (Signal, iMessage with the right settings, WhatsApp at lower assurance) protects content but not metadata at the carrier level. Mesh services (Briar, certain Matrix configurations) can protect both at significant UX cost.

### If you're an enterprise CISO

You don't operate a telecom, but your enterprise's incident response plan should explicitly address the case where the **carrier itself is compromised**. Mobile-based MFA is weaker than it was. SMS-based recovery flows are weaker than they were. Out-of-band communications during incidents should not assume that cellular metadata is private.

## What I'd watch out for

A short list of things to track over the next year:

- **The FCC's posture** as the political composition of the commission continues to evolve. Whether the rules are reinstated, modified, or replaced will be informative about how regulators end up framing similar incidents.
- **The European response.** NIS2's teeth on telecom security are real. ENISA's reporting on similar campaigns in Europe will be worth reading.
- **Specific telecom remediation disclosures.** When and whether a major U.S. carrier publicly states that Salt Typhoon has been confirmed eradicated will be a meaningful event. As of writing, no such statement exists.
- **Follow-on disclosures from other governments.** Allies have been comparing notes; expect more public detail to emerge.
- **The next CALEA-equivalent debate.** The political pressure to weaken consumer encryption "for law enforcement access" has not gone away. Salt Typhoon is now a primary argument against doing so.

## The bottom line

Salt Typhoon is the largest known intrusion into U.S. telecommunications in history. It exploited unpatched, well-documented vulnerabilities in equipment that nobody seriously claimed was unmaintainable. It has not been fully expelled from compromised networks. The regulatory response that followed has been partial and is now partly reversed. The strategic implications — particularly with respect to lawful intercept infrastructure — are not yet fully digested.

If you read one cybersecurity story of the decade carefully, this is the one.

## Related on this site

- [Why Cybersecurity Is Now National Security]({{< ref "why-cybersecurity-is-now-national-security" >}})
- [The ShinyHunters Wave of 2026]({{< ref "shinyhunters-supply-chain-wave-2026" >}})

## Sources

- [Experts Agree U.S. Communications Networks Remain Vulnerable Following Salt Typhoon Hack — U.S. Senate Committee on Commerce, Science, & Transportation](https://www.commerce.senate.gov/2025/12/experts-agree-u-s-communications-networks-remain-vulnerable-following-salt-typhoon-hack)
- [Senator doesn't trust telcos on Salt Typhoon mitigations — The Register](https://www.theregister.com/2026/02/08/infosec_news_in_brief/)
- [Salt Typhoon Cyberattack: How China Hacked 200+ Global Telecom Giants — Stockpil](https://stockpil.com/salt-typhoon-china-hacked-telecom-giants/)
- [Salt Typhoon: The Worst Telecom Hack in American History — State of Surveillance](https://stateofsurveillance.org/articles/surveillance/salt-typhoon-telecom-hack/)
- [Salt Typhoon Hacks and Federal Response Implications — Congress.gov](https://www.congress.gov/crs-product/IF12798)
- [FCC to vote on reversing cyber rules adopted after Salt Typhoon hack — Federal News Network](https://federalnewsnetwork.com/cybersecurity/2025/11/fcc-to-vote-on-reversing-cyber-rules-adopted-after-salt-typhoon-hack/)
- [Is America's Cyber Weakness Self-Inflicted? — War on the Rocks](https://warontherocks.com/2026/01/is-americas-cyber-weakness-self-inflicted/)
- [Salt Typhoon: the hack that proved backdoors are everyone's problem — RIT Cyber Self Defense](https://ritcyberselfdefense.wordpress.com/2026/03/30/salt-typhoon/)
- [China-linked Salt Typhoon hacking threat engulfs entire networks — SDxCentral](https://www.sdxcentral.com/news/china-linked-salt-typhoon-hacking-threat-engulfs-entire-networks/)
