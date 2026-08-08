---
layout: post
title: "Cache Invalidation: First Decide How Wrong A Read May Be"
date: 2026-06-12 20:40:00 +0100
categories: software engineering
tags: [cache, distributed-systems, performance, consistency]
excerpt_separator: <!--more-->
greeting: "stale is a product state"
description: "Choose cache TTL, invalidation, versioned keys, negative caching, and stampede protection from explicit staleness and failure requirements."
image:
  url: assets/images/blog/2026-06-12-cache-invalidation-strategy-cover.png
  alt: "A cache copy fading out of sync with its source while a version signal repairs it"
---
“Add Redis” is not a cache strategy. The first question is how long the application may return an old or missing value without violating the product.

<!--more-->

## Name The Staleness Budget

A product description may tolerate ten minutes. An account balance may not tolerate ten seconds. TTL follows this boundary, not a universal best practice.

Cache-aside is simple: read cache, load source on miss, populate. It also permits a race where an old read repopulates after an update invalidates.

Versioned keys or compare-before-write can protect critical paths. Event-driven invalidation reduces staleness but introduces delivery delay and duplicates.

## Prevent Stampedes

When a popular key expires, many callers may load it simultaneously. Use request coalescing, a short refresh lease, soft expiry with background refresh, or bounded stale serving.

Add jitter to TTLs so related keys do not expire on the same second.

## Negative Entries Need Shorter Suspicion

Caching “not found” can protect a source from repeated misses, but it can hide a newly created record. Give negative entries a deliberate shorter lifetime or invalidate them on create.

Measure hit rate alongside source latency, stale-serving count, load failures, and key cardinality. A 99% hit rate can still hide one dangerous stale key.

Cache makes reads cheaper by accepting another state copy. Decide how copies converge before celebrating latency.


- [Microservices Are Not A Silver Bullet: You Probably Need A Monolith](/blog/microservices-are-not-a-silver-bullet/)
- [Out-Of-Order Events: Timestamps Will Not Save Your State Machine](/blog/out-of-order-events/)
