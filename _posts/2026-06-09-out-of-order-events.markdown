---
layout: post
title: "Out-Of-Order Events: Timestamps Will Not Save Your State Machine"
date: 2026-06-09 07:30:00 +0100
categories: software engineering
tags: [messaging, events, ordering, distributed-systems]
excerpt_separator: <!--more-->
greeting: "arrival order is not business order"
description: "Protect event-driven state from out-of-order delivery with aggregate versions, monotonic transitions, partition keys, and gap recovery."
image:
  url: assets/images/blog/2026-06-09-out-of-order-events-cover.png
  alt: "Event cards arriving out of order while version gates restore a valid sequence"
---
`PaymentCompleted` can arrive before `PaymentAuthorized`. Network paths differ, retries reorder delivery, and partitions move. Sorting by event timestamp after arrival is not a complete repair.

Clocks can disagree, timestamps can tie, and late data can be valid.

<!--more-->

## Version The Aggregate

Events for one aggregate can carry a monotonically increasing version:

~~~json
{
  "paymentId": "p-42",
  "version": 7,
  "type": "PaymentCompleted"
}
~~~

A consumer holding version 6 can apply 7. If it already holds 8, event 7 is stale. If it holds 5, version 7 exposes a gap that may require waiting, replay, or fetching current state.

## Partitioning Gives Scoped Order

Many brokers preserve order only within a partition. Use the aggregate ID as partition key when per-aggregate order matters. This does not create global order, and usually you do not need one.

## Make Transitions Monotonic

A completed payment should not return to authorized because a late event arrived. Encode allowed state transitions and compare versions in the same database update.

~~~sql
update payments
set status = :status, version = :version
where id = :id and version < :version;
~~~

Affected row count is part of the result, not implementation trivia.

Event time helps analytics and business windows. Sequence and state rules protect correctness. Do not ask one timestamp field to do both jobs.


- [PostgreSQL UPSERT: One Statement Does Not Define Your Conflict Policy](/blog/postgresql-upsert-concurrency/)
- [At-Least-Once Delivery Means Duplicates: Design The Consumer First](/blog/at-least-once-delivery/)
