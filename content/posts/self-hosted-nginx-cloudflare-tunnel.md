---
title: "How I Self-Hosted This Website with Nginx and Cloudflare Tunnel"
date: 2026-05-16
draft: false
tags: ["nginx", "cloudflare", "self-hosting", "tunnel", "static-site"]
categories: ["Self-Hosting", "Infrastructure"]
series: ["Self-Hosting This Site"]
summary: "How cajunhacker.xyz is served: Hugo builds static files, Nginx serves them locally, Cloudflare Tunnel handles the public side — no inbound ports opened."
---

This site you're reading runs on a small Ubuntu VM at home. There is no inbound port forwarded on my router, no public IP exposed, and no VPS rented. Here's the shape of it.

## The stack

- **Hugo** — static site generator. Markdown in, plain HTML/CSS out.
- **Nginx** — serves the static files from `/var/www/cajunhacker` on the local machine.
- **Cloudflare Tunnel** (`cloudflared`) — opens an outbound-only connection from the server to Cloudflare's edge, and Cloudflare routes `cajunhacker.xyz` traffic back down the tunnel to my Nginx.

No database. No PHP. No admin panel. No reverse proxy on the public internet I have to keep patched.

## Why this shape

A static site removes whole categories of risk. There is no application server to compromise, no SQL to inject into, no user session to hijack. The attack surface is essentially "can the attacker find a bug in Nginx?" which is a much smaller surface than "can the attacker find a bug in WordPress, its theme, any of its forty plugins, the PHP runtime, the database, or the admin login flow?"

Cloudflare Tunnel adds a second nice property: my home IP is never exposed and I never open a port on my router. If Cloudflare drops the tunnel, the site is unreachable — but my server is also invisible. That's a tradeoff I'm comfortable with.

## The pieces

### 1. Hugo project

The source lives in `~/sites/cajunhacker`. Building produces a `public/` directory of plain files.

```bash
cd ~/sites/cajunhacker
hugo --minify
```

### 2. Nginx

Nginx is configured with one server block pointing at `/var/www/cajunhacker`:

```nginx
server {
    listen 80;
    server_name cajunhacker.xyz www.cajunhacker.xyz;
    root /var/www/cajunhacker;
    index index.html;
    location / {
        try_files $uri $uri/ =404;
    }
}
```

That's the whole config. No TLS here — TLS termination happens at Cloudflare.

### 3. Cloudflare Tunnel

`cloudflared` runs as a systemd service on the same box. It authenticates to Cloudflare with a tunnel credential and forwards `cajunhacker.xyz` traffic to `http://localhost:80`. DNS for the apex and `www` is a CNAME to the tunnel.

The tunnel is the only path in. I never opened port 80 or 443 on my router.

### 4. Deploy script

A short `deploy.sh` runs `hugo --minify`, `rsync`s `public/` to `/var/www/cajunhacker/`, fixes ownership, and reloads Nginx. Writing a new post is `hugo new posts/whatever.md`, then `./deploy.sh`.

## What I'd watch out for

- **Don't expose the cloudflared metrics port.** It can leak detail about your tunnel.
- **Don't put secrets in your Hugo content directory.** Everything in `public/` becomes public — that includes any file you accidentally drop in `static/`.
- **Patch Nginx and Ubuntu on a schedule.** Static or not, the OS is still your job.
- **Back up the Hugo source.** The deployed `public/` is regenerable; the Markdown is the asset.

## What's next

Future posts will cover the Cloudflare Tunnel install in detail, hardening Nginx beyond defaults, and how I monitor the box without exposing anything new.
