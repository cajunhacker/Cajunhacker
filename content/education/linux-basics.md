---
title: "Linux Basics"
date: 2026-05-16
description: "The Linux fluency every cybersecurity practitioner needs — what to learn and in what order."
weight: 20
---

You cannot do cybersecurity without Linux. Tools, servers, containers, embedded devices, CI runners — Linux is everywhere. This page is the floor, not the ceiling.

## What "fluent" means

- Navigate the filesystem without thinking about it: `cd`, `ls -la`, `pwd`, `find`, `which`, `realpath`.
- Read and write files: `cat`, `less`, `head`, `tail`, `tail -f`, a real editor (`vim` or `nano` — pick one and learn it).
- Use pipes and redirection: `|`, `>`, `>>`, `2>&1`, `tee`, `xargs`.
- Filter and transform text: `grep`, `sed`, `awk`, `cut`, `sort`, `uniq`, `wc`.
- Understand permissions: `chmod`, `chown`, octal vs symbolic, sticky bit, SUID, ACLs.
- Manage processes: `ps`, `top`, `htop`, `kill`, `jobs`, `bg`, `fg`, signals.
- Manage services: `systemctl`, `journalctl`, `loginctl`.
- Network tooling: `ip a`, `ip r`, `ss -tlnp`, `curl`, `dig`, `ping`, `traceroute`.
- Package management for your distro of choice: `apt` or `dnf`.
- Read logs: `/var/log/`, `journalctl -u <service>`, `dmesg`.
- Write simple shell scripts: variables, conditionals, loops, functions, exit codes.

## How to get there

1. **Install a real Linux VM.** Ubuntu Server or Debian. Avoid distros that hide things from you (looking at you, distros aimed at "ease of use").
2. **Live in it.** Use it for daily work for at least a month. Force yourself to do file management from the shell.
3. **Work through Bandit at OverTheWire.** It's free, it's progressive, and it teaches you the things you don't yet know you don't know.
4. **Read selectively.** *The Linux Command Line* by William Shotts is free and excellent. *How Linux Works* by Brian Ward is the next step.

## A practical drill

A good test of fluency: given a freshly installed Linux VM, can you, without searching:

- Set a static IP?
- Add a non-root user and put them in sudoers?
- Install and enable nginx?
- Open port 80 in the firewall?
- Find what process is listening on port 80?
- Tail the access log live?

If any of these stop you, that's your next week of study.

## Common pitfalls

- **Relying on `sudo` reflexively.** Understand *why* a command needs root before you give it.
- **Editing files in `/etc` without a backup.** `cp file file.bak` first. Always.
- **Confusing `~/.bashrc` and `~/.profile`.** Know which one your shell reads on login vs new terminals.
- **Treating "it works on my machine" as a debugging strategy.** Find the actual difference.

## What's next

- [Networking](/education/networking/) — most security work is networked work
- [Beginner Cybersecurity](/education/beginner-cybersecurity/) — the broader path
