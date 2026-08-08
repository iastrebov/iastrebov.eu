---
layout: post
title: "Your Cache Is A Memory Leak With A Hit-Rate Dashboard"
date: 2026-07-11 16:10:00 +0100
categories: software engineering
tags: [caching, memory, reliability, java]
excerpt_separator: <!--more-->
greeting: "every cache needs an exit"
description: "Prevent application caches from becoming memory leaks with bounded size, expiry, weight limits, admission policy, and honest metrics."
image:
  url: assets/images/blog/2026-07-11-cache-memory-leak-cover.png
  alt: "An overflowing cache box retaining objects while memory pressure rises"
---
Putting a map in front of a slow call is easy. Deciding what must leave the map is the actual cache design.

<!--more-->

## Bound The Resource

Time-to-live is not a memory limit. A burst can insert millions of unique keys before any entry expires. Set a maximum size or, better, a maximum weight when values vary substantially.

Choose expiry semantics deliberately. Expire-after-write limits staleness. Expire-after-access favors hot entries but can keep obsolete data alive indefinitely. Neither replaces invalidation when correctness requires immediate change.

## Admission Matters Too

Do not cache every miss. One-hit keys can evict genuinely hot data and create churn. Reject oversized values, avoid caching errors by accident, and consider whether negative results need a much shorter lifetime.

Protect against a stampede when a popular entry expires. Coalesce concurrent loads or refresh before expiry while serving a known value where the business permits it.

## Watch More Than Hit Rate

Measure entry count, estimated weight, evictions, load latency, load failures, and hit rate by meaningful operation. A 99% hit rate can still hide one unbounded tenant consuming most memory.

If the service cannot state its cache bound and invalidation rule, it does not have a cache. It has delayed heap exhaustion.

## Cache Carefully

- [Cache Invalidation: Pick The Failure You Can Tolerate](/blog/cache-invalidation-strategy/)
- [Heap Dumps Are Evidence—and A Production Hazard](/blog/heap-dump-production-safety/)
