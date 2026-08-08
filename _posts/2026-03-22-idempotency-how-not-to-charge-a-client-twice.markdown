---
layout: post
title: "Idempotency: How Not To Charge A Client Twice"
date: 2026-03-22 09:16:00 +0000
categories: software engineering
tags: [fintech, idempotency, payments, java]
excerpt_separator: <!--more-->
greeting: "retries will happen"
description: "A fintech guide to idempotency keys, safe payment retries, unique constraints, and transaction design that prevents double charges."
image:
  url: assets/images/blog/2026-03-22-idempotency-how-not-to-charge-a-client-twice-cover.png
  alt: "Second duplicate glowing credit card shattering above a cyberpunk checkout terminal"
---
If your payment API cannot handle retry, it is not payment API. It is roulette with JSON.

Networks fail. Clients timeout. Gateways return 502 after processing. Users double-click. Job runners retry. If your system charges twice because request arrived twice, architecture is guilty.

<!--more-->

## Idempotency In Plain Words

Idempotency means same operation can be safely repeated and final result stays same.

For payments, client sends unique key for business operation. Server stores it. If same key arrives again, server returns original result instead of doing side effect again.

The key is not request id from load balancer. It is operation identity.

## Database Must Enforce It

Do not trust only application cache. Cache disappears exactly when you need it.

~~~sql
create table payment_requests (
    id bigserial primary key,
    idempotency_key varchar(120) not null unique,
    account_id varchar(64) not null,
    amount numeric(19, 2) not null,
    status varchar(32) not null,
    payment_id varchar(64),
    created_at timestamp not null default now()
);
~~~

Unique constraint is boring and strong. Boring and strong is fintech aesthetic.

## Keep The Network Outside The Database Transaction

Do not keep a database transaction open while a payment provider decides whether to answer. First claim the idempotency key in a short transaction. Then call the provider using the same key, and persist the result in another short transaction.

~~~java
PaymentResult charge(ChargeCommand command) {
    PaymentRequest request = requests.claim(command); // short transaction
    if (request.hasFinalResult()) {
        return request.toResult();
    }

    Payment payment = gateway.charge(
        command.idempotencyKey(), command.accountId(), command.amount());

    return requests.complete(request.id(), payment); // short transaction
}
~~~

The unique constraint resolves racing claims. The provider key protects the remote side effect. A background reconciler must recover requests left in <code>PROCESSING</code> after a crash between the provider call and local completion.

## Store Original Response

If first request succeeds but response is lost, retry must return same response. Store enough result to answer deterministically.

If first request is still processing, return 409 or processing status. Do not start second payment because you feel optimistic.

## Key Scope Matters

Idempotency key should be unique per client or account depending on API contract. Otherwise two clients can collide accidentally or maliciously.

Also validate same key is not reused with different amount. That should be conflict, not silent success.

## Common Mistakes

Generating key on server after request arrives. Using Redis without durable store. Expiring key too fast. Not storing failed-but-final states. Retrying non-idempotent gateway calls without provider key.

Each mistake is possible duplicate charge.

## The Retry Test

Payment retries are inevitable. Double charge is optional.

Make operation identity explicit, enforce it in database, and design response path for lost network replies. This is not advanced. This is minimum professional hygiene.


- [Python Is For Scripts, Java Is For Business](/blog/python-is-for-scripts-java-is-for-business/)
- [Database Locks: The Silent Killer Of High-Load Systems](/blog/database-locks-silent-killer-high-load-systems/)
- [The Anatomy Of A Distributed Transaction](/blog/anatomy-of-a-distributed-transaction/)
