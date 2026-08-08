---
layout: post
title: "Java GC Latency: Read The Allocation Story Before Tuning Flags"
date: 2026-05-13 06:55:00 +0100
categories: software engineering
tags: [java, jvm, garbage-collection, performance]
excerpt_separator: <!--more-->
greeting: "the collector cannot fix infinite allocation"
description: "Diagnose Java GC latency through allocation rate, live-set size, pause distribution, and memory limits before copying collector flags from a talk."
image:
  url: assets/images/blog/2026-05-13-java-gc-latency-basics-cover.png
  alt: "A mechanical collector clearing short-lived objects while a live heap island remains"
---
A long garbage-collection pause is evidence, not diagnosis. Changing collector flags before you understand heap behavior is how one latency problem becomes three smaller, stranger problems.

Start with allocation and survival. The collector only manages the object story your application writes.

<!--more-->

## Four Numbers Before Any Flag

Collect these first:

- allocation rate: bytes created per second;
- live set: memory still occupied after a major collection;
- pause distribution: p50, p95, p99, and maximum;
- heap occupancy and headroom under representative load.

High allocation with a small live set suggests temporary garbage. A growing live set suggests retention or legitimate cache growth. Same symptom, different work.

## Allocation Can Be The Easier Fix

One formatting call in a hot loop may create several temporary objects. A large JSON tree may exist only to copy three fields. A debug log may serialize a payload even when the level is disabled.

Profile allocations before rewriting code. If one path creates gigabytes per minute, removing that churn is usually safer than tuning collector around it.

~~~java
if (log.isDebugEnabled()) {
    log.debug("quote={}", expensiveJson(quote));
}
~~~

The guard matters when argument construction itself is expensive.

## Heap Size Is A Latency Trade-Off

A tiny heap collects constantly. A huge heap may hide growth for longer, consume container headroom, and change pause behavior. More heap is not automatically more performance.

Inside a container, verify the JVM sees the intended memory limit and leave space for thread stacks, direct buffers, metaspace, native libraries, and the operating environment. Heap is not whole process.

## Read Distribution, Not Average

An average 8 ms pause can coexist with a 900 ms maximum that breaks a request deadline. Correlate pauses with end-to-end latency and timestamps. A pause at 02:14 is irrelevant to a spike at 02:19.

Also separate stop-the-world time from application stalls caused by locks, database waits, or CPU saturation. “GC issue” is common label for any graph that looks saw-toothed.

## Choose Collector From A Requirement

Throughput, pause target, heap size, and available CPU pull in different directions. State the service objective before switching collector. Then test with production-like allocation and traffic, not an empty health endpoint.

The disciplined order is boring: record, correlate, profile, change one thing, compare. Copying twenty JVM flags from another workload is folklore with a command line.


- [String Theory: Optimizing Memory In High-Load Systems](/blog/string-theory-optimizing-memory-high-load-systems/)
- [Clean Code Is Overrated When You Need Performance](/blog/clean-code-is-overrated-when-you-need-performance/)
