---
title: "Proxmox VE 9 Deep Dive: What Actually Changed and Whether to Upgrade"
date: 2026-05-05
draft: false
tags: ["proxmox", "homelab", "virtualization", "debian", "zfs", "ceph", "sdn", "lvm"]
categories: ["Homelab"]
summary: "Proxmox VE 9.0 dropped in August 2025 with a Debian 13 base, kernel 6.14, snapshots on thick-LVM, SDN with OpenFabric/OSPF, and HA affinity rules. A homelabber's view of what matters, what to test, and how the upgrade actually goes."
---

[Proxmox VE 9.0](https://www.proxmox.com/en/about/company-details/press-releases/proxmox-virtual-environment-9-0) landed on **August 5, 2025**. The 9.1 point release followed later that year. Nine months in, the dust has settled enough to say which of the changes are real wins, which are nice-but-narrow, and what you should test before flipping the upgrade switch on a working homelab.

This is a homelab-leaning deep dive — what mattered for me, in the [Proxmox lab](/projects/proxmox-lab/) that hosts this site and the [AD lab](/education/active-directory-lab/). If you run a 500-node cluster, your priorities will be different.

## The base: Debian 13 "Trixie" and kernel 6.14

Proxmox 9.0 rebases onto **Debian 13 Trixie** with **Linux kernel 6.14.8-2** as the stable default. This is the "you should care because it touches everything" change. Under the hood:

- New systemd version, new APT (with significant default behavior changes), new openssh, new everything else.
- The kernel jump brings hardware support for newer Intel/AMD platforms, eBPF improvements, and io_uring updates.
- Updated **QEMU 10.0.2**, **LXC 6.0.4**, **ZFS 2.3.3**, **Ceph Squid 19.2.3**.

The QEMU 10 / kernel 6.14 combination is where many of the perceived "feels faster" reports come from. It's not magic — better scheduling, better io_uring paths, fewer regressions on newer CPUs.

### What this breaks (potentially)

The Debian major-version jump is the biggest source of upgrade pain. Things to check before you upgrade:

- **Custom apt sources.** Any non-Proxmox repos need to be updated to the Trixie suite.
- **Pinned packages or held-back upgrades** from your 8.x days. Resolve these first.
- **NVIDIA drivers** if you're doing GPU passthrough — kernel ABI changes here.
- **Custom systemd units** that touched older units' contracts.
- **PHP/Python/Ruby** versions in any LXC containers, if those containers are using the host's Debian release as their base (they shouldn't be, but it happens).

The official **[upgrade guide from 8 to 9](https://pve.proxmox.com/wiki/Upgrade_from_8_to_9)** is excellent and should be the source of truth.

## The feature that actually matters: snapshots on thick-LVM shared storage

For years, Proxmox users with **shared block storage** (iSCSI or Fibre Channel SAN with LVM on top, thick-provisioned) could not snapshot VMs without going through clunky workarounds. The cost of qcow2-on-NFS or ZFS was the only path to native snapshots, and that wasn't always an option in enterprise SAN environments.

Proxmox 9 **adds snapshot support to thick-provisioned LVM shared storage**.

For homelabbers this is less directly relevant — most home setups run ZFS, LVM-thin, or qcow2-on-directory, all of which already had snapshots. But if you're studying for any kind of enterprise virtualization context (vSphere-to-Proxmox migrations, MSP work), this is the change that finally makes Proxmox a complete answer for that environment.

### Practical caveat

Snapshots on thick-LVM consume LVM extents. If your shared volume is sized tight, taking many snapshots can fill it. Plan and monitor accordingly.

## SDN gets routing protocols: OpenFabric and OSPF

The Software-Defined Networking stack picks up **"fabric"** support, including the **OpenFabric** and **OSPF** routing protocols.

Translated for the homelab:

- You can now build a multi-host Proxmox network that distributes routes dynamically.
- Useful when you have multiple Proxmox nodes and want to give VMs IPs from a defined fabric without manually managing routes everywhere.
- Mostly relevant if you're doing more than two nodes and care about resilient inter-node networking.

If you have one Proxmox node, this changes nothing for you. If you have three, it might be worth a weekend's reading.

## HA resource affinity rules

The High Availability stack adds **affinity rules** for HA resources. You can now express constraints like:

- "These two VMs should always run on different nodes." (Anti-affinity — useful for AD DC replication or any kind of HA pair.)
- "This VM should always run on the same node as this other one." (Affinity — useful when two VMs have a high-bandwidth dependency you don't want crossing the network.)

For a small cluster, this is straightforward and immediately useful. For a single-node setup, it's irrelevant.

### Concrete homelab use case

In my AD lab, the DC and a member server want to live on different nodes for realism and snapshot-isolation. The rule for that, in 8.x, was *manual* — I had to remember to put them on different boxes. In 9, the cluster enforces it for me.

## Mobile UI improvements

The web UI got a real mobile pass. Phone-based control of a Proxmox cluster is now actually usable — not just barely-survives-usable.

For the "I'm not at my desk and a VM is stuck" case, this is a quality-of-life win.

## Smaller wins worth noting

- **GUI improvements to the firewall** — the new layout is cleaner than 8.x and easier to reason about with multiple rule sets.
- **Better defaults in the installer** for ZFS root setups.
- **Backup performance** improvements on Proxmox Backup Server 4 (the matching PBS major release).
- **Updated documentation** with more example scenarios.

## Things 9 doesn't fix

To stay honest:

- **The Ceph storage learning curve** is still steep. 9 ships Ceph Squid; the operational complexity is unchanged.
- **GUI nesting** in some advanced features still requires reading the docs. The mental model isn't always obvious from the UI alone.
- **Cluster join/leave operations** still demand attention; an accidental remove of a node still bites.
- **No "magic" cross-version compatibility.** A 9.x cluster with one 8.x node will work for the duration of a planned migration, but it's not a long-term posture.

## Should you upgrade your homelab?

Three scenarios:

### Scenario 1 — Single-node Proxmox running production services for your household

**Wait a beat. Don't be on the bleeding edge.** Read the upgrade guide, snapshot or back up before you start, schedule the upgrade for a maintenance window when it's actually OK for the household to lose Plex / Home Assistant / pihole for a couple of hours. The 9.x line is now mature, but no upgrade is risk-free.

I'd target the 9.1.x point release rather than 9.0.0 vanilla. By the time you read this, 9.x has had multiple stable point releases.

### Scenario 2 — Lab cluster, services are reproducible, snapshots are cheap

**Go.** You'll learn from the upgrade, the rebase delivers real improvements, and the cost of a bad upgrade is "destroy the cluster, rebuild it from your IaC, which you have, right?"

### Scenario 3 — Production cluster running services other people depend on

**Pilot one node. Then a non-critical node. Then the rest.** This is true for any major version upgrade of any platform; nothing here is Proxmox-specific.

## How the upgrade actually goes (in practice)

I upgraded my own homelab cluster (3 nodes) over a weekend in late 2025. Real notes:

1. **Backups first.** Every VM and LXC, to PBS, with verification. Take a snapshot of the host config (`/etc/pve` and `/etc/network/interfaces`).
2. **Read the release notes end-to-end.** The Proxmox release notes are short; read them all, not just the highlights.
3. **Update 8.x to the latest point release first** — `pve8to9` is the readiness checker; run it and fix everything it complains about before starting.
4. **Upgrade one node, reboot, verify cluster health.** Migrate VMs *to* the upgraded node before doing the next one.
5. **Watch for repository surprises.** Any third-party apt source you had needs its Trixie equivalent.
6. **NVIDIA/Intel GPU passthrough.** Verify drivers come up. Plan extra time here.
7. **Verify backups work post-upgrade.** Run a restore test on a non-critical VM. The day after the upgrade is exactly the wrong time to discover backups are broken.

My upgrade took about an hour per node including verification. The cluster never lost quorum. One LXC container needed manual attention because its Python version expected an older library that Trixie no longer ships in the same shape.

## What I'd watch out for going forward

- **Snapshots on thick-LVM are new code.** Treat with appropriate skepticism for the first year. Don't bet a recovery on it without testing first.
- **SDN OpenFabric/OSPF are new code.** Same caveat.
- **Mobile UI** is useful but the mobile-induced typos are real. Be careful with destructive actions on a phone.

## The bottom line

Proxmox VE 9 is a solid major release. The Debian 13 base modernizes the platform, the thick-LVM snapshot work removes a long-standing enterprise blocker, SDN routing is real (if niche for homelabbers), and HA affinity rules quietly remove a class of operational headache for clusters. The upgrade path is well-documented and works.

For homelab use, the upgrade is worth doing on your own schedule, with backups and a test plan. For production, treat it like any other major version: pilot, observe, then roll.

## Related on this site

- [Proxmox Lab](/projects/proxmox-lab/) — my own deployment
- [Building a Proxmox Homelab for Cybersecurity Training]({{< ref "proxmox-homelab-for-cybersecurity-training" >}})

## Sources

- [Proxmox Virtual Environment 9.0 with Debian 13 released — Proxmox](https://www.proxmox.com/en/about/company-details/press-releases/proxmox-virtual-environment-9-0)
- [What's new in Proxmox VE 9.0 — Proxmox training](https://www.proxmox.com/en/services/training-courses/videos/proxmox-virtual-environment/whats-new-in-proxmox-ve-9-0)
- [Upgrade from 8 to 9 — Proxmox Wiki](https://pve.proxmox.com/wiki/Upgrade_from_8_to_9)
- [Debian 13 "Trixie" and Proxmox VE 9.0: Implementation and Testing — HOSTKEY](https://hostkey.com/blog/124-debian-13-trixie-and-proxmox-ve-90-implementation-and-testing-in-production/)
- [Proxmox 8 vs. 9 — What's New and How to Upgrade — xTom](https://xtom.com/blog/proxmox-8-vs-9-upgrade-guide/)
- [I upgraded to Proxmox 9 — here's how it went — XDA Developers](https://www.xda-developers.com/i-upgraded-to-proxmox-9/)
- [Proxmox VE 9.1 Release — community-scripts/ProxmoxVE Discussion](https://github.com/community-scripts/ProxmoxVE/discussions/9278)
