---
layout: post
title: "High-Cardinality Metrics Can Bankrupt Your Observability"
date: 2026-07-07 11:30:00 +0100
categories: software engineering
tags: [observability, metrics, cardinality, prometheus]
excerpt_separator: <!--more-->
greeting: "labels multiply"
description: "Control metric cardinality by separating bounded dimensions from request identities and choosing logs or traces for forensic detail."
image:
  url: assets/images/blog/2026-07-07-metrics-cardinality-cover.png
  alt: "A small set of metric labels exploding into an unmanageable lattice of time series"
---
One innocent label can turn a cheap metric into millions of time series.

<!--more-->

## Cardinality Multiplies

Suppose `http_requests_total` has 8 methods, 20 routes, 5 status groups, 4 regions, and 30 instances. That is already up to 96,000 combinations before retention and replicas enter the bill.

Add `user_id` or raw request path and the bound disappears. `/orders/123` and `/orders/124` become different series even though they describe the same route.

## Metrics Are For Aggregation

Use bounded labels such as route template, method, status class, region, and known operation type. Normalize dynamic paths before recording them. Never use request IDs, email addresses, exception messages, or arbitrary query parameters as labels.

Need one customer’s story? Put the identifier in structured logs or a trace. Metrics answer “is checkout slower in region A?” Logs and traces answer “what happened to request B?”

## Guard The Boundary

Estimate the product of label values during review. Set ingestion limits and alert on active-series growth. Publish a small vocabulary for service, operation, result, and region so every team does not invent a new dimension.

Histograms also multiply by bucket count. Choose buckets around meaningful latency thresholds instead of accepting a large default without looking.

Observability data should reduce uncertainty. A metric nobody can afford to retain does the opposite.

## Useful Neighbours

- [Log Like Your Job Depends On It Because It Does](/blog/log-like-your-job-depends-on-it-because-it-does/)
- [SLOs Turn Reliability From An Argument Into A Budget](/blog/slo-error-budget/)
