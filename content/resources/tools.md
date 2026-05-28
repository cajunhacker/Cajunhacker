---
title: "Tools"
date: 2026-05-16
description: "The tools I actually use for cybersecurity, self-hosting, and homelab work."
weight: 10
---

This is the working set. If a tool isn't here, it's because I don't use it regularly — not because it's bad.

## Operating systems

- **[Ubuntu](https://ubuntu.com/) Server / Debian** — daily-driver Linux for self-hosted services.
- **[Proxmox VE](https://www.proxmox.com/en/proxmox-virtual-environment)** — virtualization platform.
- **[Kali Linux](https://www.kali.org/)** — pentesting tools, run as a VM in lab.
- **[Parrot OS](https://parrotsec.org/)** — lighter Debian-based security distro; alternative to Kali.
- **Windows 11** — for native Windows tooling and to live the user experience honestly.

## Web and HTTP

- **Burp Suite Community/Pro** — proxy, repeater, intruder. The web-testing standard.
- **curl** — for everything Burp is too heavy for.
- **httpie** — when I want curl with friendlier defaults for ad-hoc testing.

## Network

- **Wireshark / tshark** — capture and analysis.
- **tcpdump** — capture on remote boxes with no GUI.
- **nmap** — port and service discovery (authorized targets only).
- **mtr** — continuous traceroute + ping.
- **ss** — listening sockets and active connections (preferred over `netstat`).

## DNS

- **dig** — DNS lookups with detail.
- **dog** — colorful modern alternative to dig when I want it.

## Reconnaissance

- **subfinder / amass** — subdomain enumeration.
- **httpx** — liveness and tech fingerprinting.
- **ffuf** — content discovery and parameter fuzzing.
- **nuclei** — known-vulnerability templates.

## Active Directory and Windows

- **BloodHound + SharpHound** — AD graph analysis.
- **Impacket** — Python AD attack toolkit.
- **NetExec** (formerly CrackMapExec) — enumeration and lateral movement.
- **Rubeus** — Kerberos abuse on Windows.
- **Mimikatz** — lab only, ever.

## Hashing and cracking

- **hashcat** — GPU cracking.
- **john** — when hashcat won't.

## Self-hosting and infrastructure

- **Hugo** — this site.
- **Nginx** — web serving.
- **Cloudflare Tunnel (cloudflared)** — public exposure without inbound ports.
- **Tailscale** — private mesh for admin access.
- **Nextcloud** — file sync, calendar, contacts.
- **Proxmox Backup Server** — backups for the homelab.
- **Docker / Podman** — for containerized services I prefer not to install on the host.

## Editor and shell

- **vim** with a deliberately minimal config.
- **VS Code** when I want a GUI editor with strong language support.
- **bash** as the default shell; **zsh** on the workstation.
- **tmux** for persistent sessions on remote hosts.

## Notes and writing

- **Obsidian** for personal notes and bug-hunting workspace.
- **Plain Markdown in git** for anything that ends up on this site.

## What I don't use

- Heavy commercial endpoint products that try to be everything. They're fine in enterprises; overkill at home.
- Closed-source security tools where the open equivalent is good enough.
- "AI-powered" security tools whose vendor can't tell me what the AI actually does.

---

## Disclaimer

**All tools and techniques presented on this website are documented for educational purposes only.**

Penetration testing, vulnerability research, and offensive security activities must only be performed against systems, networks, and applications for which you have **explicit, written authorization from the owner**. Practicing on systems you do not own or do not have documented permission to test is illegal in most jurisdictions — in the United States, this includes violations of the Computer Fraud and Abuse Act (CFAA), state computer crime statutes, and parallel laws abroad. The same applies regardless of intent: "I was just learning" is not a defense.

If you want to practice these techniques legally, options include:

- Your own lab — see the [Active Directory Lab](/education/active-directory-lab/) and [Proxmox Lab](/projects/proxmox-lab/) for setups you control end-to-end.
- Intentionally vulnerable applications you self-host (DVWA, OWASP Juice Shop, vulnerable VMs from VulnHub).
- Authorized practice platforms — see [Training Platforms](/resources/training-platforms/) for legal targets including TryHackMe, Hack The Box, PortSwigger Web Security Academy, and CTF events.
- Public bug bounty programs that publish a scope and rules of engagement — see the [Bug Bounty Workflow](/projects/bug-bounty-workflow/) page.

Nothing on this site authorizes you to test any third party's systems. Read scope documents carefully, get authorization in writing, and stay inside it. The author of this site assumes no liability for misuse of the information presented here.
