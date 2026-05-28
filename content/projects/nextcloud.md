---
title: "Nextcloud"
date: 2026-05-16
description: "Self-hosted file sync, calendar, and contacts on the home Proxmox lab."
weight: 30
---

Nextcloud replaces the bits of Google Drive / iCloud / Dropbox that I want to control myself. It runs on the home [Proxmox lab](/projects/proxmox-lab/) and is reachable only over Tailscale — it is not exposed to the public internet.

## What it does for me

- **File sync** across laptop, phone, and other devices
- **Calendar and contacts** via CalDAV/CardDAV
- **Photo backup** from the phone
- **Document collaboration** for a small number of users

## Deployment shape

- **Nextcloud All-in-One (AIO)** as the deployment method — keeps the moving parts coherent.
- Behind Tailscale's `tailscale serve`, which terminates TLS with a valid Let's Encrypt cert on a `*.ts.net` hostname.
- **No public exposure.** The Nextcloud admin and user UI are reachable only by devices on my tailnet.
- AIO admin UI bound to a specific local interface and reachable only on the local network for setup tasks.

## Why not expose it publicly

Nextcloud is a substantial PHP application with an admin panel, user authentication, and many integrations. The Project has a good track record but the attack surface is large compared to a static site. For my use case there's no benefit to public exposure — every device I care about is on Tailscale already.

## Security posture

- Admin account uses a long, unique passphrase from my password manager.
- 2FA enabled on the admin account.
- Regular updates via the AIO interface.
- Backups go to a Proxmox Backup Server target outside the Nextcloud host.
- The reverse-proxy front-end (Tailscale serve) is the only path in.

## Linked posts

- [Why I Use Tailscale for Private Server Administration]({{< ref "why-tailscale-private-admin" >}})

## Status

Running, in daily use. Mobile sync is reliable. Future write-ups will cover the backup strategy and disaster-recovery test results.
