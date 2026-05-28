---
title: "Building a Proxmox Homelab for Cybersecurity Training"
date: 2026-05-13
draft: false
tags: ["proxmox", "homelab", "virtualization", "training", "active-directory"]
categories: ["Homelab", "Infrastructure", "Cybersecurity"]
summary: "Why Proxmox is the right hypervisor for a learning lab, what hardware actually matters, and the topology I run for safe practice with vulnerable VMs."
---

If you want to seriously practice cybersecurity, you need a lab where you can break things. Cloud trials are fine for a single afternoon. For ongoing practice — recurring AD environments, malware detonation, network captures, multi-VM scenarios — a local hypervisor is cheaper, faster, and yours.

I run **Proxmox VE**. Here's why and how.

## Why Proxmox, not VMware or Hyper-V

- **Free and open.** No license server, no trial countdown, no surprise pricing emails after an acquisition.
- **Debian under the hood.** If you can use Linux, you can recover Proxmox from a bad state.
- **KVM and LXC in one UI.** Full VMs when you need them, containers when you don't.
- **Decent snapshots and backups.** Snapshot before you detonate something; roll back cleanly.
- **Cluster-capable.** Two or three nodes give you live migration if your wallet says so.

VMware Workstation is fine on a laptop. Hyper-V is fine on Windows. But if you have a dedicated box, Proxmox is the right answer.

## Hardware that actually matters

In rough order:

1. **RAM.** More than anything else. A Windows DC, a member server, a Kali attacker, and a victim workstation is 24 GB minimum if you don't want to swap. 64 GB is comfortable. 128 GB is overkill until it isn't.
2. **CPU cores.** 6+ physical cores. Hyperthreading helps with concurrency. AES-NI and virtualization extensions (VT-x / AMD-V) are mandatory.
3. **SSD.** NVMe if you can. Spinning rust will make snapshots and backups painful.
4. **A second NIC.** Useful for separating the management network from lab traffic. Not strictly required but nice.
5. **IPMI / out-of-band.** Lets you recover from a kernel that won't boot without walking to the box. Worth it on used enterprise gear.

I don't care about brand. I do care about ECC if you're storing anything you'd miss.

## Topology I run

```
                    [Home LAN / Router]
                            |
                  [Proxmox host: vmbr0]
                            |
        +-------------------+-------------------+
        |                                       |
   [vmbr1: lab network — isolated, no NAT]
        |
   +----+----+----+----+----+
   |    |    |    |    |    |
  DC1  WKS1 WKS2  Kali Web  Pi-hole
       (AD member)         (lab DNS)
```

The lab network has its own bridge (`vmbr1`), no DHCP from the home router, and no NAT to the internet unless I explicitly turn it on. Lab DNS is a Pi-hole on `vmbr1` that resolves the AD domain internally.

This means:

- I can pop a vulnerable VM and it can't talk to my home network or the public internet.
- I can turn NAT on briefly for patching or to pull a tool, then turn it back off.
- The DC has consistent DNS and time; AD doesn't fight me about it.

## What I run for training

**Active Directory lab.** A Server 2022 DC, a member server, two workstations. Vulnerable configurations rotated in: ASREP-roastable accounts, Kerberoastable service accounts, unconstrained delegation, GPO misconfigurations, weak ACLs. Tools like BadBlood and GOAD make this faster to stand up than rolling your own.

**Vulnerable web targets.** OWASP Juice Shop, DVWA, intentionally misconfigured Apache and IIS instances. Used for practicing both attack (Burp, sqlmap, manual exploitation) and defense (WAF rules, log review).

**Network capture and analysis.** A SPAN-ish setup using Linux bridges with mirroring, feeding into a Security Onion or Zeek VM.

**Detonation sandbox.** An isolated Windows VM, no network at all, used to look at samples I can't run on anything I care about.

## Practices that have saved me

- **Snapshot before every lab session.** Roll back at the end. Your lab stays clean and reproducible.
- **Name VMs by purpose, not by clever names.** Future-you doesn't remember what `frodo` was supposed to do.
- **Pin lab traffic to its bridge.** Don't let it accidentally egress your LAN.
- **Patch the Proxmox host on a schedule.** It is not part of the lab; it's the host. Treat it like production.
- **Back up the host config.** `/etc/pve`, `/etc/network/interfaces`, your VM definitions. Restoring a host is much easier when you have these.
- **Don't store sensitive data on lab VMs.** If you accidentally expose one, you don't want to lose anything that matters.

## What I'd watch out for

- **The default web UI port (8006) on the management interface.** Firewall it to your admin network. Better: only reach it over Tailscale.
- **Default `root@pam` access.** Make a non-root admin user, enable 2FA, and only use root for the things that genuinely require it.
- **Backups.** Proxmox Backup Server is excellent. Use it. A homelab is not really a lab if you can't recover from your own mistakes.

## The bottom line

Proxmox is the price-to-power sweet spot for a learning homelab. Get enough RAM, isolate the lab network, snapshot aggressively, and you'll be able to practice scenarios that no online platform can match — at your own pace, on your own terms.
