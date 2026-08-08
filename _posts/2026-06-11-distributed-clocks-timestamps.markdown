---
layout: post
title: "Distributed Clocks: createdAt Is Not A Global Sequence Number"
date: 2026-06-11 11:05:00 +0100
categories: software engineering
tags: [distributed-systems, time, ordering, architecture]
excerpt_separator: <!--more-->
greeting: "wall clocks answer the wrong ordering question"
description: "Understand clock skew, monotonic time, event ordering, and why distributed systems need versions or logical order beyond timestamps."
image:
  url: assets/images/blog/2026-06-11-distributed-clocks-timestamps-cover.png
  alt: "Several server clocks disagreeing while a separate logical sequence remains ordered"
---
Two services can emit events in causal order and stamp them in reverse order. Their wall clocks are synchronized within a tolerance, not fused into one machine.

`createdAt` is useful evidence. It is not universal sequence.

<!--more-->

## Wall Time And Duration Are Different

Use wall time for business timestamps and audit records. Use a monotonic clock for elapsed duration inside one process, because wall time can jump after synchronization adjustments.

In Java, inject `Clock` for wall-time logic and use monotonic measurement APIs for durations. Do not subtract two local date-times and call it latency.

## Ordering Needs A Scope

For one aggregate, use a database version or sequence assigned by the owner. For one broker partition, rely on its ordered offset contract. For causality across a workflow, carry explicit parent or correlation information.

A total global order is expensive and often unnecessary. Decide which competing events require comparison.

## Timestamps Still Matter

They support user display, retention, time windows, and investigation. Store instants with enough precision and keep source context when device time may be untrusted.

When correctness says “apply only if newer,” define newer through a version owned by the state machine. The wall clock should not be promoted because it was already in the payload.


- [Out-Of-Order Events: Timestamps Will Not Save Your State Machine](/blog/out-of-order-events/)
- [PostgreSQL timestamptz: Store Instants, Name Business Zones](/blog/postgresql-timestamptz-timezones/)
