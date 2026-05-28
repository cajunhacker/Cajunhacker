---
title: "Networking"
date: 2026-05-16
description: "The networking knowledge cybersecurity actually requires — TCP/IP, DNS, subnetting, routing, and how to reason about packet flow."
weight: 30
---

Security is networked. If you can't reason about how a packet gets from a laptop to a server and back, the rest of the field will feel like magic. This page is what you need to know cold.

## The model

The four-layer TCP/IP model is more useful than the seven-layer OSI model in practice, but you should know both names. Reading top-down:

- **Application** — HTTP, DNS, SSH, SMTP, the things humans care about
- **Transport** — TCP, UDP, ports, the handshake, retransmission
- **Internet** — IP, routing, fragmentation, ICMP
- **Link** — Ethernet, ARP, MAC addresses, switches

A packet leaves a process, gets a transport header, gets an IP header, gets a link header, hits the wire. Reverse on the way in. Every header is added and stripped at the appropriate layer.

## Things you should know cold

- **The TCP three-way handshake.** SYN → SYN/ACK → ACK. What flags mean (SYN, ACK, FIN, RST, PSH, URG).
- **Ports.** Well-known (0–1023), registered (1024–49151), ephemeral. The common ones: 22, 25, 53, 80, 110, 143, 443, 465, 587, 993, 995, 3306, 3389, 5432, 8080.
- **TCP vs UDP.** When you'd use each. TCP is reliable, ordered, slower to set up. UDP is fire-and-forget — DNS, NTP, QUIC, real-time audio/video.
- **IPv4 subnetting.** CIDR notation, network/broadcast/host count math, RFC 1918 private ranges. Be able to do `/24`, `/25`, `/26`, `/27` in your head.
- **IPv6.** Address shape, link-local vs global, why you'll see it whether you want to or not.
- **ARP.** How a host on a LAN finds the MAC for a given IP. Why ARP cache poisoning works.
- **DNS.** The hierarchy, the record types, the TTL trap. See the blog post [What DNS Actually Does]({{< ref "what-dns-actually-does" >}}).
- **DHCP.** The DORA exchange. What gets handed out (IP, mask, gateway, DNS).
- **NAT.** Why it exists, why it complicates everything, port forwarding vs hairpin NAT.
- **Routing.** Default gateway, routing tables, why `traceroute` works.
- **VLANs.** Tags, trunking, why segmentation is a basic security control.

## Tools to learn

```bash
ip a                    # interfaces
ip r                    # routing table
ss -tlnp                # listening sockets with owning processes
ss -tnp                 # active TCP connections
dig <name>              # DNS lookups (preferred over nslookup)
dig +trace <name>       # walk the DNS hierarchy
mtr <host>              # continuous traceroute + ping
tcpdump -i eth0 -nn port 53      # capture DNS traffic
wireshark                # GUI capture analysis
nmap -sS -p- <host>     # port scan (only against hosts you own/are authorized for)
curl -v https://example.com      # see the HTTP request and response in detail
```

Spend an afternoon with Wireshark on your own network. Watch a single HTTPS connection happen — DNS lookup, TCP handshake, TLS handshake, ciphertext, FIN. The moment you see it happen is the moment networking stops being abstract.

## A reasoning drill

You type `https://www.cajunhacker.xyz` and press Enter. List, in order, every protocol that fires before the page renders. (Hint: it's about a dozen, and DNS is at least three of them if you count recursion.)

If you can't, that's your study list.

## Common pitfalls

- **Treating "it pings" as "the network works."** ICMP and TCP can have very different fates.
- **Forgetting MTU.** VPNs, tunnels, and PPPoE love to break things in mysterious ways via MTU mismatches.
- **Assuming public DNS is your DNS.** Internal split-horizon resolvers can return different answers.
- **Ignoring IPv6 because "we're not using it."** Your OS is. So is your ISP. Plan for it.

## Further reading

- *TCP/IP Illustrated, Vol. 1* — Stevens & Fall. Worth the time.
- Beej's Guide to Network Programming — free, short, excellent for understanding sockets.
- Professor Messer's Network+ videos — free on YouTube, well-paced.

## What's next

- [Web Security](/education/web-security/) — networking specialized to HTTP
- [Active Directory Lab](/education/active-directory-lab/) — networked identity at scale
