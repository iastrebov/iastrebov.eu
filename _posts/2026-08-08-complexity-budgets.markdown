---
layout: post
title: "Set Complexity Budgets Before Optimizing Code"
date: 2026-08-08 14:00:00 +0100
categories: software engineering
tags: [algorithms, performance, architecture]
excerpt_separator: <!--more-->
greeting: hello
description: "Complexity analysis becomes practical when input limits, latency, memory, and growth assumptions are turned into explicit engineering budgets."
image:
  url: assets/images/blog/2026-08-08-complexity-budgets-cover.png
  alt: Time and memory gauges constraining alternative algorithm paths as input volume grows
---

Big-O notation describes how work grows, not whether a particular implementation is fast enough. An `O(N)` scan can be disastrous over billions of records on every request. An `O(N log N)` sort can be perfectly reasonable for a thousand items in a nightly job.

<!--more-->

Begin with a budget. State the maximum expected input, request rate, latency target, memory allowance, and execution frequency. Then estimate operation counts and allocations at that boundary. Rough arithmetic is more useful than arguing about asymptotic labels without scale.

Keep separate budgets for time and space. A lookup table may reduce CPU while increasing heap pressure and garbage collection. A streaming algorithm may use little memory but make several passes over remote storage. The limiting resource depends on where the code runs.

Account for multiplicative placement. A query that costs five milliseconds looks harmless until it runs inside a loop for every item, on every request, across hundreds of instances. Database round trips, serialization, and cache misses often dominate the local algorithm.

Use benchmarks after the model, not instead of it. Benchmark representative distributions and sizes, warm up managed runtimes appropriately, and consume results so the compiler cannot remove work. A microbenchmark cannot predict network contention or a production heap, but it can test a specific assumption about an implementation.

Write the accepted limits near the interface and enforce them. Choose controls for the operation. Reject unbounded page sizes or cap top-K requests. For large exports, stream data or move work off the request path. Monitoring should reveal when real inputs approach the assumption that justified the design.

Optimization is a trade. A more complex structure creates maintenance and correctness costs, so spend that complexity where the budget proves it necessary. The practical question is not “Which algorithm is theoretically fastest?” It is “Which simple design remains safely within its resource envelope as the workload grows?”
