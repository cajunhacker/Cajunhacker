---
title: "My Cybersecurity Learning Path"
date: 2026-05-11
draft: false
tags: ["learning", "career", "ceh", "linux", "networking", "active-directory"]
categories: ["Cybersecurity"]
summary: "What I would do if I were starting over today — in what order, why, and what I'd skip. Aimed at career-changers, transitioning service members, and anyone tired of \"top 10 hacking tools\" posts."
---

People ask me how to get into cybersecurity. The honest answer is: there is no single path, but there *is* a recognizable shape to the paths that work. This is the shape I'd follow if I were starting today.

The order matters. The temptation is to skip to the fun part. Don't.

## 1. Get fluent in Linux first

Not "I can `cd` and `ls`." Fluent: pipes, redirection, `grep`/`sed`/`awk`, file permissions, processes, systemd, package management, log files, networking with `ip` and `ss`, basic shell scripting.

Why first: every cybersecurity tool, every server you'll defend or attack, every CTF, every cloud workload — Linux is the substrate. If you have to look up "how do I see what's listening on port 22" every time, your progress is going to stall on plumbing.

**How:** OccupyTheWeb's [Linux Basics for Hackers, 2nd Edition](https://nostarch.com/linux-basics-hackers-2nd-edition) is the standard recommendation; see the full OTW series on the [Reading List](/resources/reading-list/). Install Debian or Ubuntu in a VM and live there for a few weeks. Break it on purpose. Recover. The OverTheWire Bandit wargame is excellent practice.

Target: **2–3 months of daily use** before you move on.

## 2. Learn networking like you mean it

Subnetting. The TCP/IP four-layer model. What actually happens during a TCP handshake. ARP. DNS (see [What DNS Actually Does]({{< ref "what-dns-actually-does" >}})). DHCP. NAT. Routing. VLANs. The OSI model is a teaching tool, not gospel — but you should know it.

Why second: every attack and every defense moves over the network. You cannot reason about firewalls, IDS, lateral movement, or exfiltration without an actual mental model of how packets flow.

**How:** Professor Messer's free Network+ videos are excellent. Read parts of *TCP/IP Illustrated, Vol. 1* (Stevens). Run Wireshark on your own home network for a week and label every flow.

Target: **comfortable explaining a packet's journey** from your browser to a remote server and back.

## 3. Get a foothold in cybersecurity fundamentals

Now you can start the security-specific layer:

- The CIA triad and why it's useful as a framework, not a slogan
- Authentication vs authorization vs accounting
- Symmetric and asymmetric crypto, hashing, MACs — what each is *for*
- Certificates and PKI, end to end
- Common attack categories (network, web, social, physical) and their countermeasures
- The defender's mindset: logs, alerts, baselines, deviations, response

**How:** The Security+ body of knowledge is a reasonable map. Don't necessarily sit the exam — but study the syllabus. *The Cyber Defender's Handbook* and *The Web Application Hacker's Handbook* both repay rereading.

Target: **you can describe how a phishing-to-domain-admin chain works** in plain English.

## 4. Pick a track and go deep

After fundamentals, the field forks. Pick one to start. You can broaden later.

- **Defensive (Blue Team):** logging, SIEM, threat hunting, detection engineering, incident response. Build a home SOC with Security Onion or Wazuh.
- **Offensive (Red Team):** penetration testing, vulnerability research, exploit development. Hack The Box / TryHackMe / PortSwigger Web Security Academy.
- **AppSec:** secure code review, threat modeling, SAST/DAST. The OWASP Top 10 is the floor, not the ceiling.
- **Cloud security:** AWS/Azure/GCP IAM, network policies, posture management. The cloud providers all have free tiers.
- **GRC / Risk:** policy, frameworks (NIST CSF, ISO 27001), audit. Less hands-on but the highest-leverage seat in many organizations.

You'll be more valuable, sooner, going deep in one track than skimming all five.

## 5. Build something real

Stand up an Active Directory lab. Run a vulnerable web app and find every flaw. Self-host a service and write up the security review of your own setup. Contribute a detection rule to a public Sigma repo. Write a blog post (yes, like this one).

Why: the difference between "studied cybersecurity" and "did cybersecurity" is visible to hiring managers. A GitHub or a blog with three real projects beats four certifications you can't talk about specifically.

## 6. Then, maybe, certify

If you must:

- **CompTIA Security+** if you're starting from zero and need to clear an HR filter.
- **CEH** is a credential that opens doors, especially in government and defense. It's not a deep technical test — treat it as a vocabulary exam.
- **OSCP** is hard, hands-on, and respected. Don't attempt it without prior pentesting practice.
- **CISSP** for management/architecture tracks once you have years of experience.

Certifications are receipts for knowledge you already have. They're not the knowledge.

## Things I would skip or de-prioritize

- **"Top 10 hacking tools" YouTube videos.** They teach you the noun, not the verb.
- **Anything labeled "in 30 days."** You can finish a 30-day course; you cannot become a security engineer in 30 days.
- **Buying expensive courses before you've exhausted free material.** Cybrary, TryHackMe's free tier, PortSwigger Academy, OverTheWire, INE Free, Microsoft Learn — there is more free quality content than you can finish in a year.
- **Discord servers as your primary input.** Useful for community; bad as a curriculum.

## A note for transitioning service members

The military teaches you, even if you don't realize it: structured problem-solving, threat awareness, the discipline of writing things down, comfort with classified handling, ops tempo, briefing senior leaders, and operating in teams under stress. All of that is directly relevant.

Translate your résumé. "Conducted COMSEC compliance inspections" is "performed cryptographic key management audits across N units." "Served as 6-shop chief" is "managed information systems and communications for a 600-person organization." Hiring managers in civilian cyber don't know your MOS — make it legible.

The technical bar in industry is sometimes lower than you fear and sometimes higher than you expect. Get hands-on, and don't undersell what you already know.

## The bottom line

Linux → networking → security fundamentals → one deep track → real projects → maybe certifications, in that order. Skip none of these steps. Time-box the early ones so you keep moving. Write down what you learn — the act of explaining locks it in.
