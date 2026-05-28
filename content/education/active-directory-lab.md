---
title: "Active Directory Lab"
date: 2026-05-16
description: "Building a vulnerable Active Directory environment for hands-on practice in attack and defense."
weight: 50
---

Active Directory is the identity plane of most enterprises on the planet. If you do offensive or defensive work, you will encounter AD. The fastest way to learn it is to stand up your own lab and break it on purpose.

This page is a sketch of a lab you can build over a weekend.

## What you need

- A hypervisor — [Proxmox](/projects/proxmox-lab/) is what I run; VMware Workstation or Hyper-V work fine.
- **24 GB RAM minimum** for a meaningful lab; 64 GB if you want comfort.
- Windows Server 2019 or 2022 ISO (evaluation copies are free for 180 days).
- Windows 10 or 11 ISO for member workstations.
- A Kali Linux VM as the attacker.

## Minimum viable lab

- **DC01** — Server 2022, domain controller, DNS, AD CS optional
- **WS01** — Windows 11, domain-joined member workstation, low-privileged user logged in
- **WS02** — Windows 11, domain-joined, a privileged user occasionally logs in (creating cached credentials and Kerberos tickets)
- **Kali** — attacker box on the same isolated bridge

Network: an isolated host bridge, no NAT to the internet by default. The DC handles DNS for the domain. No DHCP from your home router.

## Vulnerable configurations to introduce

Rotate these in and out. Snapshot before each scenario.

- **Kerberoastable service account** — a domain user with an SPN and a weak password.
- **ASREP-roastable account** — a user with "Do not require Kerberos preauthentication" set.
- **Unconstrained delegation** on a service.
- **Constrained delegation** with `protocol transition` misconfigured.
- **GenericAll / WriteDACL** misconfigurations on objects.
- **Weak GPO permissions** allowing low-privileged users to modify policies that apply to higher-privileged ones.
- **DCSync rights** granted unintentionally.
- **LAPS missing** so the local admin password is the same everywhere.
- **Outdated NTLM** with no SMB signing.

## Tools to install and learn

On Kali:

- **BloodHound + SharpHound** — map the graph of who can do what to whom
- **Impacket** — Python toolkit for AD attacks (`GetUserSPNs`, `GetNPUsers`, `secretsdump`, `psexec`, `wmiexec`)
- **CrackMapExec / NetExec** — quick enumeration and lateral movement
- **Rubeus** — Kerberos abuse from a Windows host
- **Mimikatz** — credential extraction (run in the lab only, ever)
- **Hashcat** — offline cracking of NTLM, Kerberos hashes, NetNTLMv2

On the DC, install:

- **Sysmon** with a sensible config (Olaf Hartong's or SwiftOnSecurity's as a starting point)
- **Windows Event Forwarding** to a central collector (a Security Onion VM works)

## Scenarios to work through

1. **Initial foothold.** Find weak service accounts, kerberoast, crack offline, log in as the service account.
2. **Recon with BloodHound.** Identify the shortest path from a low-priv user to Domain Admin.
3. **Privilege escalation.** Abuse a misconfigured ACL or delegation to escalate.
4. **Lateral movement.** Use captured credentials/tickets to move between hosts.
5. **Persistence.** Add a backdoor user, golden ticket, silver ticket — *only in your lab*.
6. **Detection.** Re-run the attack and see what Sysmon and the Windows event logs caught. Tune the gaps.

## Off-the-shelf lab kits

If you don't want to build everything by hand:

- **GOAD (Game of Active Directory)** — pre-built vulnerable lab, well-documented.
- **BadBlood** — populates an AD with realistic noise (users, groups, ACLs, GPOs).
- **DetectionLab** — defender-focused lab including Sysmon, ELK, Velociraptor, etc.

## What I'd watch out for

- **Keep the lab isolated.** No NAT to the internet unless you specifically need it. Mimikatz on a VM that can reach your home LAN is a bad time.
- **Use evaluation Windows ISOs and snapshots.** Re-arm or rebuild before 180 days.
- **Treat the host like production.** The Proxmox host is not part of the lab; it's the perimeter. Patch it. Don't run lab tools on it.
- **Document what you did.** A lab you can't reproduce a year from now is wasted effort.

## What's next

- [Networking](/education/networking/)
- [Proxmox Lab](/projects/proxmox-lab/)
- [Training Platforms](/resources/training-platforms/)
