---
layout: post
title: "Binary Search Can Find a Feasible Boundary"
date: 2026-08-06 09:00:00 +0100
categories: software engineering
tags: [algorithms, binary-search, optimization]
excerpt_separator: <!--more-->
greeting: hello
description: "Binary search applies to more than sorted arrays: when feasibility changes monotonically, it can locate the smallest or largest acceptable parameter."
image:
  url: assets/images/blog/2026-08-06-binary-search-on-answer-cover.png
  alt: A monotonic range repeatedly divided to isolate the first feasible boundary
---

Some optimization problems are easier to verify than to construct. Given a candidate capacity, can the workload finish within the deadline? Given a rate limit, does the queue remain bounded? If feasibility changes monotonically, binary search can locate the boundary.

<!--more-->

The key is a predicate such as `feasible(x)`. For a minimum-capacity problem, values below the answer are false and values at or above it are true. Binary search finds the first true value without enumerating every possibility.

```java
long low = smallestPossible;
long high = knownFeasible;

while (low < high) {
    long mid = low + (high - low) / 2;
    if (feasible(mid)) {
        high = mid;
    } else {
        low = mid + 1;
    }
}
return low;
```

Most bugs live in the contract, not the loop. Prove monotonicity. Define whether bounds are inclusive. Establish that the upper bound is truly feasible. Use overflow-safe arithmetic in both midpoint calculation and the predicate. Multiplying large values can silently reverse a feasibility check’s answer.

Test the boundary directly: the returned value must be feasible, and the previous value must be infeasible when it exists. Include cases where the answer equals the lower or upper bound. These assertions reveal off-by-one errors better than a large random example.

For real-valued answers, iteration count or tolerance replaces exact adjacency. Be explicit about numerical error and whether the final value must be rounded up to remain safe. Binary search does not make a noisy or non-monotonic measurement reliable.

This technique is sometimes called “binary search on the answer,” but the name can obscure its reasoning. You are searching an ordered decision space whose predicate changes once. When that invariant holds, the method replaces construction with a sequence of yes-or-no checks. It helps when checking feasibility costs less than direct optimization.
