---
layout: post
title: "Transactional Outbox In Spring: Commit Data And Intent Together"
date: 2026-05-23 09:05:00 +0100
categories: software engineering
tags: [spring, outbox, messaging, distributed-systems]
excerpt_separator: <!--more-->
greeting: "publish after commit is a failure window"
description: "Implement a transactional outbox in Spring so database state and event intent commit atomically, then publish with idempotent consumers."
image:
  url: assets/images/blog/2026-05-23-transactional-outbox-spring-cover.png
  alt: "A database row and event envelope locked into one atomic shipping container"
---
Save an order, publish an event. Two lines, two systems, one gap where your process can die.

If the database commits and the broker publish never happens, downstream state is stale. Reversing the order only changes which inconsistency you get.

<!--more-->

## Store The Intent In The Same Transaction

~~~java
@Transactional
OrderId place(PlaceOrder command) {
    Order order = orders.save(Order.from(command));
    outbox.save(new OutboxMessage(
        UUID.randomUUID(), "OrderPlaced", order.id().value(), eventJson(order)));
    return order.id();
}
~~~

Order and outbox row commit together in one database. No broker call happens while transaction holds locks.

## A Relay Owns Delivery

A separate process or scheduled worker reads unpublished rows, sends them, then records delivery. It must expect a crash after broker accepts the message but before the row is marked sent.

That means duplicate delivery is normal. Consumers need an event ID and durable deduplication or naturally idempotent handling.

~~~sql
create unique index processed_event_id_uq
    on processed_events(event_id);
~~~

## Ordering Has A Scope

Global order is expensive and usually unnecessary. Preserve order per aggregate key when the business needs it, and include a version so consumers can detect gaps or stale messages.

Clean old rows with a retention policy. Monitor oldest unpublished age, relay failures, batch size, and poison messages. An outbox table without operations is only a slower missing-event bug.

The pattern does not provide exactly-once effects. It provides atomic local state plus repeatable delivery intent. That smaller promise is honest and useful.


- [The Anatomy Of A Distributed Transaction](/blog/anatomy-of-a-distributed-transaction/)
- [Idempotency: How Not To Charge A Client Twice](/blog/idempotency-how-not-to-charge-a-client-twice/)
