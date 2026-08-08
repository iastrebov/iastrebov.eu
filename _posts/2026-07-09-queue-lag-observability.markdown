---
layout: post
title: "Queue Depth Lies: Measure The Age Of Work"
date: 2026-07-09 13:50:00 +0100
categories: software engineering
tags: [queues, observability, latency, distributed-systems]
excerpt_separator: <!--more-->
greeting: "one old message can matter"
description: "Monitor queue health with oldest-message age, processing latency, throughput, retries, and in-flight work instead of depth alone."
image:
  url: assets/images/blog/2026-07-09-queue-lag-observability-cover.png
  alt: "A short queue hiding one visibly aged message beside a clock"
---
A queue of ten messages can be healthy at noon and catastrophic at midnight. Depth has no meaning without arrival rate, service rate, and age.

<!--more-->

## Age Reveals Stalled Work

Measure the age of the oldest ready message and, when possible, age by partition or work class. One poisoned message repeatedly retried can hide inside a shallow queue while its deadline expires.

Also separate time waiting from time processing. End-to-end age says what users experience; handler duration says where consumers spend time.

## Throughput Explains The Trend

Track enqueue rate, completion rate, retry rate, dead-letter rate, and active consumers. If arrivals exceed completions, depth is a slope, not a snapshot. Estimate time to exhaustion or deadline breach from that slope.

Do not treat in-flight work as completed. A consumer can fetch a large batch, make visible depth fall, then stall with all records hidden behind a long visibility timeout.

## Alert On A Broken Promise

Choose thresholds from the job’s actual deadline: an email may tolerate minutes; fraud screening may not tolerate seconds. Page on sustained age or predicted breach, and attach the partition, consumer group, and recent deployment context.

Queue dashboards should answer two questions quickly: “Are we keeping up?” and “Which work is already too old?” Depth alone answers neither reliably.

## Continue The Thread

- [Backpressure: Fast Producers Need Permission To Continue](/blog/backpressure-overload-control/)
- [At-Least-Once Delivery Means Your Handler Runs Again](/blog/at-least-once-delivery/)
