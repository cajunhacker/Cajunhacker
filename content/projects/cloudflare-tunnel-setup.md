---
title: "Cloudflare Tunnel Setup"
date: 2026-05-16
description: "Publishing self-hosted services to the internet without opening inbound ports."
weight: 20
---

A Cloudflare Tunnel is how I publish this site (and other services) to the public internet without opening any inbound port on my home router. The tunnel client (`cloudflared`) makes an outbound connection to Cloudflare's edge; Cloudflare routes public traffic to that connection.

## Why a tunnel instead of port forwarding

- **No inbound exposure.** My home IP is not advertised. Nothing on my LAN is reachable from the internet unless the tunnel routes it.
- **Cloudflare in front of everything.** DDoS protection, TLS termination, edge caching for static assets, and access controls if I enable them.
- **No NAT or dynamic DNS gymnastics.** ISP changes my IP? Doesn't matter — the tunnel re-anchors.
- **Per-hostname routing.** I can publish different services on different subdomains, all through the same tunnel.

## Architecture

```
[Browser] — HTTPS → [Cloudflare Edge]
                          │
                   (outbound from home)
                          │
                  [cloudflared on Ubuntu VM]
                          │
                    localhost:80
                          │
                       [Nginx]
                          │
                /var/www/cajunhacker
```

The arrow direction matters: `cloudflared` initiates the connection *out*. Nothing reaches in.

## What's exposed and what isn't

- **Exposed:** `cajunhacker.xyz` and `www.cajunhacker.xyz` → Nginx static content.
- **Not exposed:** SSH, Proxmox UI, Tailscale-served internal services, Docker daemons, databases, the cloudflared metrics endpoint, anything else.

## Operational notes

- `cloudflared` runs as a systemd service and starts on boot.
- The tunnel credential file lives in `/etc/cloudflared/` with restrictive permissions; it does **not** live in git.
- The site's DNS is managed in Cloudflare — the apex and `www` are CNAMEs to the tunnel.
- TLS is terminated at Cloudflare. Nginx serves plain HTTP only on `localhost`. This is appropriate because the link between cloudflared and Nginx is on the same host's loopback.

## Linked posts

- [How I Self-Hosted This Website with Nginx and Cloudflare Tunnel]({{< ref "self-hosted-nginx-cloudflare-tunnel" >}})
- [Why I Use Tailscale for Private Server Administration]({{< ref "why-tailscale-private-admin" >}})

## Status

Running, stable. The site you're reading is the proof. A full step-by-step install guide is a planned blog post.
