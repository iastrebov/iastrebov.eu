---
layout: post
title: "Sliding Windows Remove Repeated Work"
date: 2026-08-07 14:00:00 +0100
categories: software engineering
tags: [algorithms, performance, data-structures]
excerpt_separator: <!--more-->
greeting: hello
description: "A sliding-window algorithm updates a contiguous range incrementally, avoiding repeated scans when the window state can be added and removed safely."
image:
  url: assets/images/blog/2026-08-07-sliding-window-cover.png
  alt: A fixed analysis frame moving across a data stream while reusing retained state
---

Many sequence problems ask about a contiguous range: requests in the last minute, the longest substring under a limit, or the maximum value in each block. Recomputing every range from scratch repeats almost all the same work.

<!--more-->

A sliding window maintains two boundaries and enough state to update the answer when either boundary moves. For a fixed-size sum, add the entering value and subtract the leaving value. Each element participates in a constant amount of work.

Variable windows require a monotonic condition. Expand the right boundary, then advance the left boundary until the range becomes valid again. This works for constraints such as “at most K distinct values” because removing elements cannot increase the distinct count.

```java
Map<Character, Integer> counts = new HashMap<>();
int left = 0;
for (int right = 0; right < text.length(); right++) {
    counts.merge(text.charAt(right), 1, Integer::sum);
    while (counts.size() > k) {
        char c = text.charAt(left++);
        counts.compute(c, (key, n) -> n == 1 ? null : n - 1);
    }
    best = Math.max(best, right - left + 1);
}
```

Do not force the technique onto non-monotonic constraints. With negative numbers, for example, shrinking a range does not always decrease its sum, so a common positive-number window algorithm becomes incorrect. Prefix sums or another method may fit better.

For a moving maximum, a deque can hold candidate indices in decreasing value order. Remove expired indices from the front and dominated values from the back. The front then identifies the maximum without scanning the full window.

In stream processing, “window” also requires a time model. Event time, processing time, late arrivals, and memory retention change the semantics. The algorithmic idea remains incremental reuse, but the system must define when a real-world window is considered complete.
