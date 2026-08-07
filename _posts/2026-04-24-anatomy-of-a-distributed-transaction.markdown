---
layout: post
title: "The Anatomy Of A Distributed Transaction"
date: 2026-04-24 20:19:00 +0100
categories: software engineering
tags: [distributed-systems, saga, fintech, architecture]
excerpt_separator: <!--more-->
greeting: "compensate, do not pretend"
description: "A fintech system design guide to distributed transactions, why 2PC hurts cloud systems, and how the Saga pattern handles failures."
image:
  url: assets/images/blog/2026-04-24-anatomy-of-a-distributed-transaction-cover.png
  alt: "Glowing node map where one red failed node causes data pulse to reverse safely"
---
Distributed transaction is where architecture stops being diagram and starts asking what happens when third service fails after first two succeeded.

If your answer is "it should not fail", please leave design meeting.

<!--more-->

## Why 2PC Hurts In Cloud

Two-phase commit coordinates participants so all commit or all roll back. Nice on paper. In cloud-native service world it creates tight coupling, blocking, coordinator risk, and poor availability.

Your payment service, ledger service, notification service, and partner gateway do not all want one global lockstep dance.

## Saga Pattern

Saga splits business transaction into steps with compensating actions.

Text diagram:

~~~text
1. Reserve funds        -> compensation: release funds
2. Create payment       -> compensation: cancel payment
3. Notify provider      -> compensation: mark provider retry/cancel
4. Confirm ledger entry -> compensation: reversal entry
~~~

If step 3 fails after step 1 and 2, saga runs compensations or moves into recoverable state.

## State Machine, Not Hope

~~~text
PENDING
  -> FUNDS_RESERVED
  -> PROVIDER_SENT
  -> COMPLETED
  -> COMPENSATING
  -> COMPENSATED
  -> FAILED_MANUAL_REVIEW
~~~

Every state must be durable. Every transition idempotent. Every retry safe.

## Java Shape

~~~java
@Transactional
void handle(PaymentSaga saga) {
    switch (saga.state()) {
        case PENDING -> reserveFunds(saga);
        case FUNDS_RESERVED -> callProvider(saga);
        case PROVIDER_SENT -> confirmLedger(saga);
        case COMPENSATING -> compensate(saga);
        default -> throw new IllegalStateException("Unhandled state " + saga.state());
    }
}
~~~

This is simplified, but important part is explicit state.

## Compensation Is Not Undo

Money already moved? You may need reversal transaction, not delete row. Email already sent? You cannot unsend. Provider already charged? You need refund.

Compensation is business action, not magic rollback.

## Observability Is Mandatory

Saga without trace id, dashboard, retry count, and manual recovery tooling is future nightmare.

Distributed transactions fail in partial states. You must see them.

## Final Rule

Do not pretend distributed system can behave like one local database transaction.

Model steps, make state durable, make retries idempotent, and design compensation like real product feature.

## Related reading

- [Microservices Are Not A Silver Bullet: You Probably Need A Monolith](/blog/microservices-are-not-a-silver-bullet/)
- [Idempotency: How Not To Charge A Client Twice](/blog/idempotency-how-not-to-charge-a-client-twice/)
- [Database Locks: The Silent Killer Of High-Load Systems](/blog/database-locks-silent-killer-high-load-systems/)
