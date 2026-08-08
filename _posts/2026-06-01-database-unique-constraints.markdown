---
layout: post
title: "Unique Constraints Are Business Logic With Teeth"
date: 2026-06-01 15:20:00 +0100
categories: software engineering
tags: [database, constraints, concurrency, data-integrity]
excerpt_separator: <!--more-->
greeting: "pre-checks lose races"
description: "Use database unique constraints for business identity, handle concurrent inserts, and translate violations without trusting fragile pre-checks."
image:
  url: assets/images/blog/2026-06-01-database-unique-constraints-cover.png
  alt: "Two identical business keys racing toward one database slot guarded by a steel constraint"
---
`if (!repository.exists(email)) insert(user)` is not uniqueness. Two requests can both observe absence and both insert.

The database must arbitrate the race.

<!--more-->

## Encode The Actual Scope

Global email uniqueness uses one column. Tenant-local uniqueness needs a composite constraint.

~~~sql
alter table users
add constraint users_tenant_email_uq unique (tenant_id, normalized_email);
~~~

Normalization is part of identity. Decide case, whitespace, Unicode, and provider-specific email rules before constraint, not after duplicates arrive.

For soft deletion, decide whether a deleted identity remains reserved. A partial unique index may express active-only uniqueness in databases that support it.

## Keep The Friendly Pre-Check If Useful

A pre-check can produce fast feedback. It cannot be authority. Catch the constraint violation from the insert and translate only the known constraint to a conflict.

Do not turn every integrity violation into “already exists.” A missing foreign key or check failure is different bug.

## Generated Keys Are Not Business Identity

Two rows can have different surrogate IDs and still represent the same provider event, username, or idempotency key. Keep the numeric primary key if useful, then add a unique constraint for the domain identity.

Constraints make invalid state harder from every writer, including scripts and future services. That is business logic with a stronger execution engine.


- [Idempotency: How Not To Charge A Client Twice](/blog/idempotency-how-not-to-charge-a-client-twice/)
- [Validation Boundaries In Spring: DTO Checks Are Not Domain Rules](/blog/validation-boundaries-spring-api/)
