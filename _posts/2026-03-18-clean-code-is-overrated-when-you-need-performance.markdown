---
layout: post
title: "Clean Code Is Overrated When You Need Performance"
date: 2026-03-18 22:48:00 +0000
categories: software engineering
tags: [performance, java, clean-code, algorithms]
excerpt_separator: <!--more-->
greeting: "measure before purity"
description: "A performance-focused post showing when clean abstractions and Java Streams should give way to measured, ugly, faster loops."
image:
  url: assets/images/blog/2026-03-18-clean-code-is-overrated-when-you-need-performance-cover.png
  alt: "Beautiful organized toolbox beside a greasy chaotic high-performance race engine"
---
Clean Code is good advice for most business logic. Most.

There is remaining 5% where pretty abstraction burns CPU, allocates garbage, and loses money. In hot path, performance is feature.

<!--more-->

## Do Not Start Ugly

First write clear code. Add tests. Measure. Find actual bottleneck. Then optimize only bottleneck.

Premature ugliness is amateur. Measured ugliness is engineering.

## Stream Version

~~~java
BigDecimal total = transactions.stream()
    .filter(Transaction::settled)
    .map(Transaction::amount)
    .reduce(BigDecimal.ZERO, BigDecimal::add);
~~~

Readable. Fine for many cases.

But in high-volume path with millions records, streams can allocate, create lambdas, and hide costs. BigDecimal itself is heavy too.

## Hot Path Version

~~~java
long totalMinorUnits = 0L;
for (int i = 0; i < transactions.size(); i++) {
    Transaction tx = transactions.get(i);
    if (tx.settled()) {
        totalMinorUnits += tx.amountMinorUnits();
    }
}
~~~

Less elegant. Faster if profiler says this loop matters. Uses long minor units instead of BigDecimal allocation.

## Architecture Still Matters

Do not optimize controller formatting while database query scans table. Do not hand-roll parser because you dislike library. Performance work starts with measurement.

Java Flight Recorder, async-profiler, allocation profiling, database plans. Tools before opinions.

## Rule Breaking Needs Fence

When code is intentionally ugly for speed, isolate it.

~~~java
/** Hot path. Keep allocation-free. Benchmark before changing. */
final class SettlementAccumulator { ... }
~~~

Add benchmark. Add tests. Explain constraint. Future developer should not "clean" it into slower version.

## Competitive Programming Lesson

CP teaches that constant factors matter. Enterprise teaches that humans maintain code. Real senior balances both.

Clean code everywhere is dogma. Fast chaos everywhere is also dogma.

## Final Rule

Write clean by default. Break rules only when profiler gives reason and tests give safety.

Pretty slow code in trading path is not moral victory.

## Related reading

- [String Theory: Optimizing Memory In High-Load Systems](/blog/string-theory-optimizing-memory-high-load-systems/)
- [Competitive Programming: Superpower Or Waste Of Time?](/blog/competitive-programming-superpower-or-waste-of-time/)
- [REST Is Lazy. Use gRPC For Real Systems](/blog/rest-is-lazy-use-grpc-for-real-systems/)
