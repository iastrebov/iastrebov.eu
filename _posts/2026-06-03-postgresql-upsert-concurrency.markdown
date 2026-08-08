---
layout: post
title: "PostgreSQL UPSERT: One Statement Does Not Define Your Conflict Policy"
date: 2026-06-03 19:45:00 +0100
categories: software engineering
tags: [postgresql, upsert, concurrency, sql]
excerpt_separator: <!--more-->
greeting: "conflict handling needs meaning"
description: "Use PostgreSQL INSERT ON CONFLICT with a deliberate conflict target, conditional update, returned state, and protection against stale writers."
image:
  url: assets/images/blog/2026-06-03-postgresql-upsert-concurrency-cover.png
  alt: "Two concurrent inserts meeting at a conflict junction with update and ignore tracks"
---
UPSERT closes the race between “check whether row exists” and “insert it.” It does not decide which writer should win or whether an update is valid.

<!--more-->

## Target A Real Identity

~~~sql
insert into provider_events(provider, external_id, payload, version)
values ($1, $2, $3, $4)
on conflict (provider, external_id)
do update set payload = excluded.payload,
              version = excluded.version
returning id, version;
~~~

The conflict target must match a unique business identity. Without a supporting constraint, concurrency protection is imaginary.

## Do Not Let Old Data Win

Out-of-order events can overwrite newer state. Add a condition:

~~~sql
on conflict (provider, external_id)
do update set payload = excluded.payload,
              version = excluded.version
where provider_events.version < excluded.version;
~~~

Now a stale event performs no update. Your application must interpret the returned row count and decide whether stale is success, warning, or conflict.

`DO NOTHING` also needs semantics. It may mean “duplicate already processed,” or it may hide a payload mismatch under the same key. Compare immutable fields when identity reuse is unsafe.

Observe conflict frequency separately from ordinary inserts. A sudden increase can reveal retry storms, duplicate delivery, or clients reusing an identifier incorrectly even when every statement completes successfully.

One statement gives atomic conflict handling. Domain rules still decide target, winner, and response.


- [Unique Constraints Are Business Logic With Teeth](/blog/database-unique-constraints/)
- [Idempotency: How Not To Charge A Client Twice](/blog/idempotency-how-not-to-charge-a-client-twice/)
