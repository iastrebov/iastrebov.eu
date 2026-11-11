---
layout: post
title: "Virtual Threads Still Block: Find The Pin Before Production Does"
date: 2026-05-12 19:15:00 +0100
categories: software engineering
tags: [java, virtual-threads, concurrency, performance]
excerpt_separator: <!--more-->
greeting: "cheap threads still need honest locks"
description: "Understand Java virtual-thread blocking, pinning, synchronized sections, native calls, and why higher concurrency can expose a smaller bottleneck faster."
image:
  url: assets/images/blog/2026-05-12-virtual-threads-pinning-cover.png
  alt: "Thousands of light fibers narrowing through one overheated metal locking pin"
---
Virtual threads make waiting cheap. They do not make databases faster, remove connection limits, or turn every lock into harmless detail.

Increase concurrency without inspecting bottlenecks and you can reach the same wall with much greater enthusiasm.

<!--more-->

## Blocking Is The Point

A virtual thread may unmount from its carrier while waiting for supported blocking I/O. The carrier can run another virtual thread, so code keeps a direct blocking style without dedicating one operating-system thread per request.

~~~java
try (var executor = Executors.newVirtualThreadPerTaskExecutor()) {
    Future<Customer> customer = executor.submit(() -> customerClient.fetch(id));
    Future<List<Order>> orders = executor.submit(() -> orderClient.fetch(id));
    return new Page(customer.get(), orders.get());
}
~~~

This improves thread scalability. It says nothing about whether the two remote calls have deadlines or whether the work cancels together after one failure.

## What Pinning Means

A virtual thread is pinned when it cannot unmount from its carrier during a blocking operation. The cause depends on the JDK version.

In JDK 21–23, blocking inside `synchronized` could pin the carrier. JDK 24 removed monitor-related pinning through JEP 491, so that explanation does not apply to ordinary monitor blocking on Java 25. [Oracle documents the JDK 24 change](https://docs.oracle.com/en/java/javase/24/migrate/significant-changes-jdk-24.html).

Native methods and foreign-function calls can still pin virtual threads. Check the [virtual-thread scheduling documentation](https://docs.oracle.com/en/java/javase/25/core/virtual-threads.html) for the runtime you deploy.

~~~java
synchronized (lock) {
    return remoteClient.fetch(); // slow I/O while monitor is held
}
~~~

On Java 25, this example still holds the monitor during remote I/O. That serializes callers sharing the lock, even without pinning.

The deeper design smell is holding a lock around remote I/O. Replacing `synchronized` mechanically may hide the signal without fixing ownership.

Keep critical sections short. Move the network call outside the lock. If the lock protects a state transition, capture the required state under the lock. Release the lock. Perform I/O. Reacquire the lock and reconcile against current state.

## Pools Still Have Capacity

A service with ten thousand virtual threads and a 30-connection database pool still runs at roughly 30 concurrent database operations. The remaining calls wait. That can be correct, but queueing time needs a budget.

Do not enlarge every pool together. You will move saturation into the database, partner API, CPU, or memory.

## Observe Before Tuning

Use Java Flight Recorder events, thread dumps, latency histograms, connection-pool metrics, and dependency timings. Look for long monitor ownership and requests waiting behind bounded resources.

Tests should cover cancellation and timeouts, not only successful fan-out. Load tests should include a slow dependency because a fast stub hides queue buildup.

Virtual threads remove one historical tax: idle platform threads. Excellent. They do not remove backpressure, deadlines, or capacity planning. Those are architecture, not thread implementation.


- [Master Structured Concurrency In Java 25](/blog/master-structured-concurrency-in-java-25/)
- [Database Locks: The Silent Killer Of High-Load Systems](/blog/database-locks-silent-killer-high-load-systems/)
