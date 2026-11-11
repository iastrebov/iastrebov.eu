---
layout: post
title: "At-Least-Once Delivery Means Duplicates: Design The Consumer First"
date: 2026-06-08 13:50:00 +0100
categories: software engineering
tags: [messaging, distributed-systems, idempotency, kafka]
excerpt_separator: <!--more-->
greeting: "redelivery is normal operation"
description: "Handle at-least-once message delivery with durable consumer deduplication, atomic state changes, poison-message policy, and safe retries."
image:
  url: assets/images/blog/2026-06-08-at-least-once-delivery-cover.png
  alt: "Duplicate message envelopes arriving at one consumer deduplication checkpoint"
---
A consumer updates the database, then crashes before acknowledging the message. The broker delivers it again. Nothing is broken; at-least-once delivery is keeping its promise.

Your consumer must keep its promise too.

<!--more-->

## Record Message Identity Atomically

When the business update and deduplication record share a database, commit them together.

~~~sql
insert into processed_messages(consumer, message_id)
values (:consumer, :message_id)
on conflict do nothing;
~~~

Only perform the business change when this insert claims a new ID, inside the same transaction. An in-memory cache does not survive restart and cannot arbitrate replicas.

## Idempotent State Transitions Are Better

Some operations are naturally repeatable. Examples include setting order status to a specific version, upserting a newer snapshot, or creating a row under a unique event key.

“Increment balance by 10” is not naturally idempotent. It needs event identity or a ledger entry constraint.

## Poison Messages Need An Ending

Retrying malformed data forever blocks a partition and burns resources. Define attempt limits, dead-letter or quarantine behavior, alerting, and replay tooling.

Acknowledgement timing, transaction boundary, and broker semantics must be tested together. A unit test that invokes the handler once does not cover delivery.

Duplicates are not rare edge case. They are part of the protocol. Put them in first test, not last incident.


- [Transactional Outbox In Spring: Commit Data And Intent Together](/blog/transactional-outbox-spring/)
- [Idempotency: How Not To Charge A Client Twice](/blog/idempotency-how-not-to-charge-a-client-twice/)
