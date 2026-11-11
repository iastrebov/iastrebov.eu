---
layout: post
title: "Consistent Hashing Limits Remapping, Not Imbalance"
date: 2026-08-05 09:00:00 +0100
categories: software engineering
tags: [algorithms, distributed-systems, hashing]
excerpt_separator: <!--more-->
greeting: hello
description: "Consistent hashing reduces key movement when nodes change, but production designs still need virtual nodes, weighting, replication, and hot-key controls."
image:
  url: assets/images/blog/2026-08-05-consistent-hashing-cover.png
  alt: Keys and storage nodes arranged around a ring with a small remapped segment
---

With `hash(key) % nodeCount`, adding one node changes the divisor and remaps most keys. That can turn a routine scale-out into a cache-miss storm or a large data migration. Consistent hashing arranges both nodes and keys on a ring so a membership change moves only nearby ranges.

<!--more-->

Hash each key to a point on the ring and assign it to the next node clockwise. Adding a node takes responsibility for the interval immediately before it. Removing a node transfers that interval to its successor. Most other assignments remain unchanged.

One point per physical node usually distributes unevenly, especially with a small cluster. Virtual nodes place each physical node at many points around the ring. They smooth the distribution and allow a larger machine to receive more points than a smaller one. The tradeoff is a larger routing table and more ownership fragments to manage.

Consistent hashing also says nothing about replication. A storage system may assign the next distinct nodes on the ring as replicas. It must also define failure-domain separation, consistency behavior, and repair after membership changes. A cache client may only need deterministic routing and tolerate loss.

Hot keys remain hot. A perfect distribution of key counts cannot divide one celebrity key that receives half the traffic. Replication, request coalescing, local caching, or application-level partitioning must address that workload separately.

Membership needs a stable view. If clients disagree about the ring, the same key reaches different nodes and hit rates collapse or writes diverge. Version the topology, roll changes deliberately, and observe remap volume and per-node load.

Modern systems may use rendezvous hashing for simpler node scoring and similar minimal movement. The underlying question is the same: how much state should move when membership changes? Consistent hashing is valuable when remapping is expensive, but it is only the placement mechanism—not a complete distributed storage design.
