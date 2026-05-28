---
title: "Why Static Sites Are Better for Security-Focused Personal Websites"
date: 2026-05-12
draft: false
tags: ["static-site", "hugo", "wordpress", "security", "self-hosting"]
categories: ["Cybersecurity", "Self-Hosting"]
summary: "If your personal site is a Markdown notebook and not an e-commerce store, a static generator beats WordPress on every axis that matters: attack surface, performance, cost, and maintenance load."
---

I work in security. I'm not going to run WordPress for a personal blog. Here's the case for static sites, made plainly.

## What "static" means

A static site is a folder of pre-built `.html`, `.css`, `.js`, and image files. A web server hands them to browsers verbatim. There is no application running on each request, no database query, no template being rendered server-side, no session state.

A static **site generator** (Hugo, Eleventy, Astro, Jekyll, Zola) takes Markdown plus templates and produces that folder at build time. You generate once and serve forever — until your next change.

## The security case

### Attack surface

WordPress, at minimum, runs PHP, MySQL, an admin panel reachable from the internet, and a session system. A typical WordPress site also runs 10–40 plugins, each with its own CVE history.

A static site runs **a web server**. That's it. No PHP runtime to exploit, no database to inject into, no admin login to brute-force, no plugin to leave unpatched.

This is not a small difference. The 2023–2025 WordPress CVE list is dominated by plugin vulnerabilities, many of them unauthenticated remote code execution. Static sites are not vulnerable to any of these, because the entire mechanism that hosts them does not exist.

### Patching load

A WordPress site demands attention. Core updates, theme updates, plugin updates, PHP version bumps, database engine upgrades — each one a chance for something to break, and skipping them is how sites get owned.

A static site needs the web server (Nginx or Caddy) patched on the same cadence as the rest of the OS. That's it. The generator runs on your laptop and never touches production.

### Secrets and credentials

A WordPress site has database credentials in `wp-config.php`, an admin password somewhere in your password manager (hopefully), and API keys in various plugin settings. Each of these is a thing to rotate and a thing to leak.

A static site has none of these in production. The deploy may have credentials (an SSH key, a token), but they live on your laptop, not on the public server.

### Blast radius

If a static site gets compromised, the attacker can only deface it — they can't extract a customer database that doesn't exist or pivot to other tenants of a CMS. And restoring is `rsync` from your build directory.

## The other reasons

### Performance

A static `.html` file served by Nginx is roughly as fast as the internet allows. There is no rendering to do, no cache layer to manage, no database query to optimize. Time-to-first-byte is essentially RTT plus disk.

### Cost

I host this site on a small home VM. Nginx serves it for free. Cloudflare Tunnel is free at this scale. There is no managed database, no PaaS, no per-request pricing.

### Versioning

Markdown content lives in git. Every change is a commit. Rolling back to last week's version is `git checkout` and rebuild. There's no "database snapshot" step.

### Authoring

I write posts in any text editor. I preview locally with `hugo server`. There's no admin UI to babysit, no "block editor" to fight, no plugin compatibility to worry about.

## When static is wrong

Static is not always the right answer. You need something dynamic if you have:

- **Real user accounts.** Authentication needs server-side state.
- **User-submitted content** that appears on the site (comments, posts, reviews).
- **E-commerce with inventory and checkout.**
- **Anything personalized per visitor** that can't be done with client-side JS hitting an API.

For a personal site, a blog, a documentation site, a homelab notebook, or marketing pages — none of those apply.

## What I run

This site is Hugo + Nginx + Cloudflare Tunnel. The Markdown source is in git. Deploys are one shell script. Patches are `apt upgrade` on a normal schedule. I don't think about it the rest of the time, which is exactly the point.

## The bottom line

For a security-focused personal site, "static" isn't a hipster aesthetic — it's the option with the smallest attack surface, the lowest maintenance load, and the smallest blast radius. The tradeoff (no dynamic features) is the price you wanted to pay anyway.
