# Cajun Hacker

Source for [cajunhacker.xyz](https://cajunhacker.xyz) — a static cybersecurity, self-hosting, and homelab site.

## Stack

- **[Hugo](https://gohugo.io/)** static site generator (extended)
- **[PaperMod](https://github.com/adityatelange/hugo-PaperMod)** theme (vendored as a git submodule)
- **Nginx** serving the built files from `/var/www/cajunhacker`
- **Cloudflare Tunnel** terminating public TLS and routing traffic to local Nginx

No database. No PHP. No admin panel. No tracking.

## Repository layout

```
~/sites/cajunhacker/
├── archetypes/         # frontmatter templates for `hugo new`
├── assets/             # asset pipeline inputs (CSS, JS to be processed by Hugo)
├── content/            # Markdown source — this is what you edit
│   ├── about.md
│   ├── contact.md
│   ├── posts/          # blog posts
│   ├── education/      # education landing + subsection pages
│   ├── projects/       # projects landing + per-project pages
│   └── resources/      # resources landing + tools/links/reading/training
├── data/               # structured data files (currently empty)
├── i18n/               # translations (currently empty)
├── layouts/            # site-specific template overrides (currently empty)
├── public/             # build output — do not edit by hand, do not commit
├── static/             # files copied verbatim into public/ (favicon, robots.txt, etc.)
├── themes/PaperMod/    # vendored theme (git submodule)
├── hugo.toml           # site configuration
├── deploy.sh           # build + rsync + reload nginx
└── README.md
```

## Prerequisites

- Hugo extended (`hugo version` should show `+extended`)
- git
- rsync
- sudo access to run `rsync`, `chown`, and `systemctl reload nginx`

On the current server these are all installed.

## Adding a new blog post

```bash
cd ~/sites/cajunhacker
hugo new content/posts/my-new-post.md
```

This creates a new Markdown file with frontmatter, marked `draft: true`. Edit the title, set appropriate `tags` and `categories`, and write the post in Markdown. When you're ready to publish, change `draft: true` to `draft: false`.

### Recommended frontmatter

```yaml
---
title: "My New Post"
date: 2026-05-16
draft: false
tags: ["topic1", "topic2"]
categories: ["Self-Hosting"]
summary: "One-sentence summary used in lists and the RSS feed."
---
```

### Canonical blog categories

These are the categories listed on the Blog landing page. Use them so posts appear under the right index:

- `Cybersecurity` — Cybersecurity Articles
- `Self-Hosting`
- `Bug Bounty` — Bug Bounty Notes
- `Homelab` — Linux / Homelab
- `Infrastructure` — Cloudflare / Tailscale / Proxmox

A post can have multiple categories.

## Adding pages to other sections

- **Education:** create a Markdown file in `content/education/` (e.g., `content/education/cryptography.md`). The Education landing page is `content/education/_index.md`; update its list if you want a manual nav link.
- **Projects:** same pattern in `content/projects/`.
- **Resources:** same pattern in `content/resources/`.

## Building locally

To build to `public/` without serving:

```bash
hugo --minify
```

To preview with a live-reloading dev server on `http://localhost:1313`:

```bash
hugo server -D    # -D includes drafts
```

The dev server does not write to `public/` — it serves from memory. The `public/` directory is only used when you run a real build (which `deploy.sh` does).

## Deploying

```bash
./deploy.sh
```

This will:

1. `hugo --minify` — build the site to `public/`
2. `sudo rsync -av --delete public/ /var/www/cajunhacker/` — sync to the Nginx web root (the `--delete` flag removes files in the destination that no longer exist in the source)
3. `sudo chown -R www-data:www-data /var/www/cajunhacker` — fix ownership
4. `sudo nginx -t` — validate the running Nginx config
5. `sudo systemctl reload nginx` — graceful reload

To see what would change without copying:

```bash
./deploy.sh --dry-run
```

## After a deploy: quick sanity checks

```bash
curl -I http://localhost/                               # local Nginx
curl -I https://www.cajunhacker.xyz/                    # public, via Cloudflare Tunnel
curl -s https://cajunhacker.xyz/sitemap.xml | head      # sitemap is generated
curl -s https://cajunhacker.xyz/index.xml | head        # RSS feed is generated
```

## Updating the theme

The PaperMod theme is a git submodule. To pull updates:

```bash
git submodule update --remote themes/PaperMod
hugo --minify     # rebuild and check nothing broke
```

After a theme update, test locally with `hugo server` before deploying.

## What not to put in this repository

- Cloudflare tunnel credentials (`/etc/cloudflared/*`).
- Private keys of any kind.
- API tokens, passwords, or other secrets.
- Large binary assets that aren't actually used on the site.

Anything you place in `static/` becomes publicly downloadable from the site root. Treat it as public.

## License

Site content © Scott Landry, all rights reserved. Theme is MIT-licensed by its author (see `themes/PaperMod/LICENSE`).
