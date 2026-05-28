---
title: "Why I Use Tailscale for Private Server Administration"
date: 2026-05-15
draft: false
tags: ["tailscale", "wireguard", "ssh", "self-hosting", "zero-trust"]
categories: ["Self-Hosting", "Infrastructure", "Cybersecurity"]
summary: "Cloudflare Tunnel handles the public side of my homelab. Tailscale handles the private side — SSH, admin UIs, and anything that should never face the internet."
---

If [Cloudflare Tunnel]({{< ref "self-hosted-nginx-cloudflare-tunnel" >}}) is how the public reaches my site, **Tailscale is how I reach my servers**. The two solve very different problems and I run them side by side.

## What Tailscale is, briefly

Tailscale is a managed WireGuard mesh. You install it on each device, log in, and every device gets a stable private IP on your "tailnet" — a flat network only your authenticated devices can join. There's no inbound port to open and no VPN concentrator to maintain.

## What I use it for

- **SSH to homelab boxes** — every server is reachable at a `*.tail<id>.ts.net` hostname from my laptop, phone, or whatever device is currently logged into my tailnet. The SSH port is firewalled off the public internet entirely.
- **Admin UIs** — Proxmox, Nextcloud admin, router GUI, anything that should never be exposed. They listen only on the Tailscale interface (or on `localhost` with Tailscale Serve fronting them).
- **MagicDNS** — short, stable hostnames so I'm not memorizing IPs.
- **Cross-site reachability** — when I'm traveling, my homelab is one keystroke away. Same setup whether I'm on hotel Wi-Fi or LTE.

## Why not just expose SSH publicly?

SSH with keys is reasonably secure, but "reasonably secure" is the wrong target for an admin plane. Reasons I keep SSH off the public internet:

1. **No exposure means no exploitation.** No CVE in OpenSSH can hurt a port nobody can reach.
2. **No log noise.** A publicly reachable SSH port gets thousands of brute-force attempts a day. Filtering that signal out is wasted work.
3. **No password fallback risk.** If I (or some future me) misconfigure something and password auth comes back on, it's not on the internet for someone to find.
4. **Defense in depth.** Tailscale's identity layer (SSO + MFA + device posture) sits *in front of* my SSH keys. An attacker would need to compromise my SSO account, my device, *and* my keys.

## Why not WireGuard directly?

I've run plain WireGuard. It works fine. Tailscale buys me:

- **Identity-aware access** tied to my SSO, with per-device approval.
- **Key rotation and ACLs** I don't have to script.
- **NAT traversal** that actually works without me running my own coordination server.
- **Tailscale Serve** for TLS termination of internal services, which is a real time-saver.

For a homelab and personal infrastructure, the managed coordination plane is worth it. If you have policy reasons to self-host the coordinator, Headscale is a drop-in option.

## A pattern that works well

For services that need to be private but want HTTPS (like an internal admin panel):

1. Bind the service to `localhost`.
2. Run `tailscale serve` to expose it on a `*.ts.net` hostname with a valid TLS cert from Let's Encrypt.
3. Restrict who in your tailnet can reach it via ACLs.

That gives you a real HTTPS URL only your authenticated devices can hit, with zero public exposure and no certs to renew manually.

## What I'd watch out for

- **Don't enable subnet routing carelessly.** It can blur the boundary between your tailnet and your LAN in ways you didn't intend.
- **Mind your ACLs.** The default "everyone in your tailnet can reach everything" is fine for a solo homelab but wrong for anything multi-user.
- **Audit your devices periodically.** Old phones, retired laptops, and forgotten VMs should be evicted from the tailnet.

## The bottom line

Public traffic goes through Cloudflare Tunnel. Admin traffic goes through Tailscale. The two are complementary, and together they let me run a homelab where nothing is exposed and everything is reachable — but only to me.
