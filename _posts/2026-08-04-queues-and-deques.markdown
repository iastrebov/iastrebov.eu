---
layout: post
title: "Queues and Deques Encode Processing Order"
date: 2026-08-04 09:00:00 +0100
categories: software engineering
tags: [algorithms, data-structures, java]
excerpt_separator: <!--more-->
greeting: hello
description: "Queues and deques are simple data structures with important ordering guarantees. Choosing the right end operations keeps workflows clear and efficient."
image:
  url: assets/images/blog/2026-08-04-queues-and-deques-cover.png
  alt: Ordered work items entering and leaving a double-ended processing channel
---

A queue is not merely a list with fewer methods. It states an ordering rule: work enters at one end and leaves at the other. That rule makes breadth-first search, buffering, and fair task processing easier to verify because old work cannot be bypassed accidentally.

<!--more-->

In Java, `ArrayDeque` is a strong default for an in-memory queue or stack. Adding and removing at either end is amortized constant time, and contiguous storage usually has less allocation overhead than a linked structure.

```java
Deque<Job> pending = new ArrayDeque<>();
pending.addLast(first);

while (!pending.isEmpty()) {
    Job job = pending.removeFirst();
    for (Job next : job.followUps()) {
        pending.addLast(next);
    }
}
```

The paired method names make the policy visible. `addLast` plus `removeFirst` is FIFO queue behavior. `addLast` plus `removeLast` is LIFO stack behavior. A deque also supports algorithms that need to discard obsolete candidates from both sides, such as a sliding-window maximum.

Choose failure semantics deliberately. Methods such as `removeFirst` throw when empty; `pollFirst` returns `null`. Throwing can expose a violated invariant, while polling fits a loop where emptiness is expected. Do not store `null` as an element if `null` also represents “no result.”

An in-memory queue provides ordering, not durability or concurrency safety. It loses work with the process and `ArrayDeque` is not safe for unsynchronized concurrent mutation. Cross-thread handoff needs a concurrent queue or blocking queue; cross-process jobs need a broker or persistent design with acknowledgment and duplicate handling.

Data structures are useful when their invariant matches the problem. Choose a queue to preserve arrival order, a stack to revisit the newest item first, and a deque when the algorithm genuinely needs both ends—not because it exposes more methods.
