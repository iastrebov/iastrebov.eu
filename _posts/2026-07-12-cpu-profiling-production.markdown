---
layout: post
title: "Profile CPU Before Optimizing The Code You Suspect"
date: 2026-07-12 17:20:00 +0100
categories: software engineering
tags: [performance, profiling, java, jvm]
excerpt_separator: <!--more-->
greeting: "a flame graph beats intuition"
description: "Investigate CPU regressions with controlled profiles, representative load, wall-clock context, and evidence that separates symptoms from hot code."
image:
  url: assets/images/blog/2026-07-12-cpu-profiling-production-cover.png
  alt: "A clean flame graph revealing one narrow tower of expensive CPU work"
---
The slow-looking method in a code review is often irrelevant. The hot path is the path that consumes measured time under real load.

<!--more-->

## Establish The Condition

Record throughput, latency, CPU utilization, allocation rate, GC activity, and the exact workload during the regression. High latency with low CPU points toward waiting, locks, I/O, or downstream limits—not arithmetic optimization.

Capture a profile long enough to represent the problem and short enough to avoid mixing unrelated traffic. Prefer sampling profilers for production investigations; measure their overhead in your environment.

## Read Both Dimensions

CPU samples show where processors execute. Wall-clock or off-CPU views reveal sleeping, blocking, and lock contention. A thread waiting on a connection pool barely consumes CPU but can dominate request latency.

In a flame graph, width represents accumulated samples, not “bad code.” Follow the widest stacks, then connect them to a request or job that matters.

## Change One Thing

Form a concrete hypothesis, make one change, repeat the same load, and compare profiles as well as user-visible latency. Microbenchmarks are useful only when they reproduce the relevant operation and avoid dead-code or warm-up traps.

Optimization without a baseline is storytelling with faster syntax.

## Evidence First

- [Java Flight Recorder: Production Evidence Without Guesswork](/blog/java-flight-recorder-production/)
- [Clean Code Is Overrated When You Need Performance](/blog/clean-code-is-overrated-when-you-need-performance/)
