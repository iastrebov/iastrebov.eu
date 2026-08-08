---
layout: post
title: "Trace Sampling: Keep The Weird Requests, Not Just One Percent"
date: 2026-07-08 12:40:00 +0100
categories: software engineering
tags: [observability, tracing, sampling, distributed-systems]
excerpt_separator: <!--more-->
greeting: "rare failures deserve better odds"
description: "Design trace sampling that preserves errors and slow outliers while controlling volume, propagation consistency, and storage cost."
image:
  url: assets/images/blog/2026-07-08-trace-sampling-cover.png
  alt: "A filter retaining rare red and slow traces from a dense stream of ordinary requests"
---
Keeping a random 1% of traces controls cost. It also gives a rare production failure a 99% chance of disappearing.

<!--more-->

## Head Sampling Is Cheap And Blind

Head sampling decides near request start. It is fast, consistent when the decision propagates, and cannot know whether the request will later fail or take eight seconds.

Use it for broad baseline coverage. Make sure downstream services honor the same decision; independent coin flips create broken traces and confusing volume.

## Tail Sampling Sees The Outcome

Tail sampling buffers spans and decides after completion. It can retain errors, slow requests, unusual routes, or selected tenants while sampling ordinary success aggressively.

The price is more memory, latency, and collector complexity. A collector failure can also discard the very evidence you wanted.

## Build A Portfolio

Keep all critical errors, a high share of latency outliers, and a small random baseline. Add explicit rules for low-volume, high-value operations. Apply rate limits so an error storm does not become an observability outage.

Record the sampling policy and effective rate with the trace. Otherwise analysts may treat a biased sample as representative traffic.

Sampling is not merely a percentage knob. It is a decision about which unknown incidents will remain debuggable.

## Follow The Signal

- [High-Cardinality Metrics Can Bankrupt Your Observability](/blog/metrics-cardinality/)
- [Out-Of-Order Events: Time Is Not A Sorting Strategy](/blog/out-of-order-events/)
