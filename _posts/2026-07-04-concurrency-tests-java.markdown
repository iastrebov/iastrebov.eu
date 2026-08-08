---
layout: post
title: "Java Concurrency Tests: Coordinate The Race, Do Not Pray For It"
date: 2026-07-04 10:15:00 +0100
categories: software engineering
tags: [testing, concurrency, java, database]
excerpt_separator: <!--more-->
greeting: "sleep does not schedule a collision"
description: "Test Java concurrency with barriers, repeated schedules, invariant assertions, database constraints, and time-bounded failure diagnostics."
image:
  url: assets/images/blog/2026-07-04-concurrency-tests-java-cover.png
  alt: "Two concurrent workers released by one barrier into a controlled database race"
---
Starting two threads and sleeping 50 ms does not guarantee a race. It guarantees your test contains a nap.

<!--more-->

## Force The Interesting Interleaving

Use latches or barriers so both workers read the same initial state before either writes. Then release them together and assert the durable invariant.

~~~java
var ready = new CountDownLatch(2);
var go = new CountDownLatch(1);

Runnable debit = () -> {
    ready.countDown();
    go.await();
    service.debit(accountId, money("80.00"));
};
~~~

The production code must still synchronize through a version, lock, or atomic database statement. The test coordination only makes collision repeatable.

## Assert Outcome Set

Concurrent order may vary. Assert allowed outcomes: one debit succeeds, one conflicts, final balance remains valid. Do not require thread A to win unless business contract says so.

Add timeouts and dump thread state on hangs. Run stress iterations for algorithms whose interleavings cannot be fully directed, but keep deterministic regression for every found bug.

Do not let the test harness introduce its own data race. Collect outcomes in thread-safe structures, propagate worker exceptions to the test thread, and close executors in a `finally` block. Otherwise a green assertion may simply mean a failed worker disappeared unnoticed.

Concurrency testing is about invariants under schedules, not making CI “busy enough.”

## Related Concurrency Risks

- [Database Locks: The Silent Killer Of High-Load Systems](/blog/database-locks-silent-killer-high-load-systems/)
- [Transaction Isolation Levels: Name The Anomaly You Cannot Accept](/blog/transaction-isolation-levels/)
