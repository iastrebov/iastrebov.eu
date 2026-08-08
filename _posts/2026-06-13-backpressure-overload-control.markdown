---
layout: post
title: "Backpressure: Fast Producers Need Permission To Continue"
date: 2026-06-13 08:05:00 +0100
categories: software engineering
tags: [distributed-systems, backpressure, queues, reliability]
excerpt_separator: <!--more-->
greeting: "infinite queues are delayed failures"
description: "Apply backpressure with bounded queues, admission control, demand signals, and overload responses before latency and memory collapse."
image:
  url: assets/images/blog/2026-06-13-backpressure-overload-control-cover.png
  alt: "A fast producer stream slowed by a measured pressure valve before a bounded consumer queue"
---
When producers create work faster than consumers finish it, the excess must wait, be rejected, be sampled, or be dropped. There is no fifth option called “autoscaling later.”

<!--more-->

## A Queue Hides Overload Temporarily

An unbounded executor queue keeps accepting work while wait time grows. Eventually requests time out before execution, memory rises, and the process spends resources on already-abandoned tasks.

Bound queue size from the maximum useful wait and throughput. Reject early with a clear overload response when capacity is gone.

## Pull Makes Demand Visible

Streaming systems can let consumers request a bounded number of elements. Message consumers can limit in-flight records and pause fetching when downstream pools saturate.

Pushing without feedback moves the overload boundary into memory.

## Different Work Deserves Different Admission

Do not let a bulk export consume every slot needed for payment authorization. Separate pools, queues, or concurrency limits by workload and business priority.

Track queue depth, oldest item age, rejection count, service time, and end-to-end latency. Depth alone misses a stuck queue containing one ancient item.

Backpressure is not pessimism. It is how a system says “this much work can be completed honestly.”


- [Database Connection Pool Sizing: More Connections Can Make You Slower](/blog/database-connection-pool-sizing/)
- [Timeout Budgets: Your 200 ms Service Cannot Make Three 200 ms Calls](/blog/timeout-budget-distributed-systems/)
