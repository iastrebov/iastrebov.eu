---
layout: post
title: "API Rate Limiting: Count The Resource You Are Protecting"
date: 2026-06-19 20:05:00 +0100
categories: software engineering
tags: [api, rate-limiting, reliability, security]
excerpt_separator: <!--more-->
greeting: "requests have different prices"
description: "Design API rate limits by identity, operation cost, burst tolerance, shared state, and overload behavior instead of one requests-per-minute number."
image:
  url: assets/images/blog/2026-06-19-api-rate-limiting-cover.png
  alt: "Different-cost API requests passing through weighted token buckets toward protected capacity"
---
One health check and one report export are both HTTP requests. They do not cost the same CPU, database time, or partner quota.

A single global requests-per-minute limit protects almost nothing precisely.

<!--more-->

## Choose Identity Carefully

Limit by authenticated account, API key, tenant, device, or IP according to threat and product. IP-only limits punish offices behind NAT and are easy to rotate in hostile traffic. Account-only limits do not protect login endpoints before authentication.

Layer limits where necessary.

## Preserve Small Bursts

Token buckets allow a bounded burst while enforcing a longer average. Sliding-window approximations provide different fairness and storage trade-offs. State whether the limit protects average rate, concurrency, or both.

Expensive operations can consume multiple tokens. Also cap in-flight requests so a client cannot hold every worker with slow calls while staying under arrival rate.

## Fail Clearly

Return `429 Too Many Requests` for client-specific rate limits and provide retry guidance where accurate. Overloaded infrastructure may need a different response because the caller did nothing wrong.

Distributed counters are approximate unless coordination is strong. Decide acceptable overshoot and behavior during limiter-store failure. Fail-open versus fail-closed is product and security policy, not library default.

Measure rejected requests by reason and identity class. A limiter that blocks good traffic silently becomes self-inflicted outage.


- [Backpressure: Fast Producers Need Permission To Continue](/blog/backpressure-overload-control/)
- [Timeout Budgets: Your 200 ms Service Cannot Make Three 200 ms Calls](/blog/timeout-budget-distributed-systems/)
