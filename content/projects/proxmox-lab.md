---
title: "Proxmox Lab"
date: 2026-05-16
description: "The Proxmox virtualization platform that hosts everything in my homelab."
weight: 10
---

Proxmox VE is the hypervisor that hosts every other project on this site — VMs for self-hosted services, isolated networks for [Active Directory practice](/education/active-directory-lab/), and the build environment for this website.

## Why Proxmox

- Free, open, and not subject to surprise relicensing.
- Debian under the hood — recoverable with normal Linux skills.
- KVM (full VMs) and LXC (containers) in one UI.
- Good snapshots, decent backups, optional clustering.
- An active community and clear documentation.

The long-form rationale is in the blog post [Building a Proxmox Homelab for Cybersecurity Training]({{< ref "proxmox-homelab-for-cybersecurity-training" >}}).

## Hardware

In rough order of impact: **RAM > NVMe > cores > NIC count > IPMI**. I treat ECC as nice-to-have on a learning box and mandatory if I'm storing anything I'd miss.

## Network design

Two bridges:

- `vmbr0` — bridged to my home LAN. Management interface, and any service that genuinely needs reachability from the home network.
- `vmbr1` — isolated lab network. No DHCP from the home router, no NAT to the internet by default. AD lab and detonation VMs live here.

When a lab VM needs the internet briefly (for patching), I enable NAT on the host for that bridge and disable it when done.

## Security posture

- The web UI (`https://<host>:8006`) is not reachable from the public internet. It's only on the home LAN and over Tailscale.
- A non-root admin user with 2FA, used for day-to-day. `root@pam` reserved for genuine emergencies.
- Backups go to a Proxmox Backup Server on a different machine.
- Host patches on a regular cadence — the host is not part of the lab; it's the perimeter.

## Linked posts

- [Building a Proxmox Homelab for Cybersecurity Training]({{< ref "proxmox-homelab-for-cybersecurity-training" >}})
- [Active Directory Lab](/education/active-directory-lab/)

## Status

Running, stable, in active use. Future posts will cover backup strategy, cluster setup, and a more detailed network diagram.
