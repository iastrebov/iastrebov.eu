---
layout: post
title: "A Load Test Is Only As Honest As Its Traffic Model"
date: 2026-07-13 18:30:00 +0100
categories: software engineering
tags: [performance, load-testing, reliability, capacity]
excerpt_separator: <!--more-->
greeting: "average traffic proves little"
description: "Build credible load tests from arrival patterns, data distribution, dependency behavior, warm-up, saturation, and explicit pass criteria."
image:
  url: assets/images/blog/2026-07-13-realistic-load-testing-cover.png
  alt: "A test rig sending varied traffic waves through a service until a clear bottleneck appears"
---
Sending a constant stream of identical requests proves that one synthetic stream can run. Production is rarely that polite.

<!--more-->

## Model Arrivals, Not Just Users

Use observed request mixes, payload sizes, key popularity, think time, bursts, and regional patterns. If the generator waits for each response before sending more work, a slowing system may receive less pressure exactly when production would keep arriving.

Keep test data representative. A database where every query hits the same warm row says little about a large, skewed customer set.

## Include The System Around The Service

Decide which dependencies are real, stubbed, or deliberately degraded. Watch connection pools, queue age, database locks, CPU, memory, GC, retries, and downstream errors—not only the load generator’s percentile chart.

Warm up runtimes and caches, then run long enough to expose leaks, compaction cycles, autoscaling delays, and slow resource exhaustion. A five-minute victory can precede the hour-two collapse.

## Define Failure Before Running

State throughput, latency percentiles, error rate, and resource headroom required to pass. Then increase load beyond the target to find the knee and observe recovery after overload.

A useful test produces a capacity statement with assumptions. “Handled 10,000 requests” is not one.

## Build On This

- [Backpressure: Fast Producers Need Permission To Continue](/blog/backpressure-overload-control/)
- [Database Connection Pool Sizing: More Connections Can Make You Slower](/blog/database-connection-pool-sizing/)
