---
layout: post
title: "Use a Bounded Heap for Streaming Top-K"
date: 2026-08-06 14:00:00 +0100
categories: software engineering
tags: [algorithms, heaps, streaming]
excerpt_separator: <!--more-->
greeting: hello
description: "A min-heap of K elements finds the largest K items without sorting an entire stream, while making memory and comparison costs explicit."
image:
  url: assets/images/blog/2026-08-06-top-k-with-heaps-cover.png
  alt: A bounded priority heap retaining only the strongest items from a continuous stream
---

Sorting every item to keep the largest ten is wasteful when the input contains millions of records or arrives as a stream. A min-heap bounded to `K` retains the current winners and exposes the weakest winner at its root.

<!--more-->

This example requires `K > 0`. For `K = 0`, return an empty result before the loop. Reject negative values.

For each item, add it while the heap contains fewer than `K` elements. After that, compare it with the root. If it is no better, discard it. If it is better, replace the root.

```java
PriorityQueue<Item> top = new PriorityQueue<>(
    Comparator.comparingLong(Item::score)
);

for (Item item : source) {
    if (top.size() < k) {
        top.add(item);
    } else if (item.score() > top.peek().score()) {
        top.poll();
        top.add(item);
    }
}
```

The algorithm uses `O(K)` memory and `O(N log K)` time. The heap does not return results in descending order; sort the final `K` items if presentation requires it. That final `O(K log K)` work is usually small.

Define ties before implementation. If two items have the same score, should both qualify, should an earlier timestamp win, or should an identifier provide deterministic order? A comparator inconsistent with the business rule can make results change across runs.

For the smallest `K`, reverse the structure: keep a max-heap so the largest current winner is easiest to evict. When `K` approaches `N`, full sorting or a selection algorithm may be simpler. When scores change after insertion, either insert immutable snapshots or use a data structure designed for updates.

Distributed top-K can merge local candidates: each partition emits its top `K`, then a final bounded heap selects from their union. This works because an item excluded from a partition's local top `K` cannot enter the global top `K`. The heap is effective here because its invariant matches exactly what the stream needs to remember—and nothing more.
