---
layout: post
title: "PostgreSQL JSONB: Flexible Schema, Permanent Query Bill"
date: 2026-05-31 09:35:00 +0100
categories: software engineering
tags: [postgresql, jsonb, data-modeling, sql]
excerpt_separator: <!--more-->
greeting: "flexibility moves cost into reads"
description: "Use PostgreSQL JSONB for genuinely flexible attributes without hiding core columns, constraints, indexes, and migrations inside one document."
image:
  url: assets/images/blog/2026-05-31-postgresql-jsonb-tradeoffs-cover.png
  alt: "A flexible JSON document drawer surrounded by growing query and index machinery"
---
JSONB is useful when part of a record is sparse, external, or evolves independently. It is dangerous when a team uses one `payload` column to postpone every data-model decision.

<!--more-->

## Keep Core Questions Relational

If you filter, join, validate, or aggregate a field in normal business flows, a typed column is usually clearer.

Store payment `status`, `merchant_id`, `amount`, and timestamps as columns. Provider-specific metadata can live in JSONB when its shape varies.

~~~sql
create table payments (
    id bigint primary key,
    merchant_id bigint not null,
    status text not null,
    amount numeric(19,2) not null,
    provider_metadata jsonb not null default '{}'::jsonb
);
~~~

## Index The Query You Have

GIN indexes support useful containment and key operations but can be large and expensive to update. Expression indexes may be smaller for one hot path:

~~~sql
create index payments_provider_reference
on payments ((provider_metadata ->> 'reference'));
~~~

Now document expected type and missing-key behavior. JSON strings containing numbers do not behave like numeric columns.

## Validation Did Not Disappear

The application still needs schema checks for important payloads. A malformed document may survive writes and fail six months later during reporting.

JSONB also changes migration style, not the need for migration. Backfill new shapes in batches, support old and new readers during transition, and measure index growth.

Use JSONB to contain real variability. Using it to avoid understanding the domain is hiding mess under one comfortable operator.


- [Stop Using ORMs Like A Junior](/blog/stop-using-orms-like-a-junior/)
- [Your API Is A Mess: 5 Rules For Backward Compatibility](/blog/your-api-is-a-mess-5-rules-for-backward-compatibility/)
