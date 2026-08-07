---
layout: post
title: "Database Locks: The Silent Killer Of High-Load Systems"
date: 2026-04-08 16:12:00 +0100
categories: software engineering
tags: [database, locking, java, fintech]
excerpt_separator: <!--more-->
greeting: "concurrency lives in database too"
description: "A Java and SQL guide to optimistic and pessimistic locking, lost updates, deadlocks, and safe fintech balance changes."
image:
  url: assets/images/blog/2026-04-08-database-locks-silent-killer-high-load-systems-cover.png
  alt: "Tiny glowing digital wrench jamming a giant steel vault door with sparks"
---
High-load systems often die quietly inside database lock queue.

Application logs say request timed out. Database knows truth: transactions waited, rows locked, deadlocks formed, and nobody designed concurrency.

<!--more-->

## Lost Update

Two transfers read same balance 100. Both subtract 80. Both save 20. Customer spent 160 and system thinks 80.

This is not edge case. This is normal traffic plus bad design.

## Pessimistic Locking

Lock row before changing it.

~~~sql
select id, balance
from accounts
where id = ?
for update;
~~~

Then update in same transaction.

~~~java
@Transactional
void debit(AccountId id, Money amount) {
    Account account = accountRepository.findForUpdate(id)
        .orElseThrow(() -> new UnknownAccountException(id));

    account.debit(amount);
    accountRepository.save(account);
}
~~~

Simple and safe for some flows. But locks reduce concurrency. Keep transaction short.

## Optimistic Locking

Add version column.

~~~sql
update accounts
set balance = ?, version = version + 1
where id = ? and version = ?;
~~~

If updated rows = 0, someone changed account first. Retry or fail with conflict.

Optimistic locking works well when conflicts are rare.

## Deadlock Pattern

Transfer A locks account 1 then 2. Transfer B locks account 2 then 1. Database picks victim.

Fix by deterministic lock order.

~~~java
List<AccountId> ordered = Stream.of(from, to)
    .sorted(Comparator.comparing(AccountId::value))
    .toList();

accounts.lockInOrder(ordered);
~~~

Now transactions acquire locks in same order.

## Do Not Hold Locks During Network Calls

Never lock account row, call external provider, wait two seconds, then update. You just converted database into waiting room.

Separate reservation, external call, confirmation. Use saga or state machine.

## Monitor Locks

Track lock wait time, deadlocks, transaction duration, slow queries, and connection pool saturation. If app threads wait for database, your service latency explodes.

## Final Rule

Concurrency is not only Java threads. Database is concurrent system with rules.

Know those rules before money moves through it.

## Related reading

- [Master Structured Concurrency In Java 25](/blog/master-structured-concurrency-in-java-25/)
- [Idempotency: How Not To Charge A Client Twice](/blog/idempotency-how-not-to-charge-a-client-twice/)
- [Stop Using ORMs Like A Junior](/blog/stop-using-orms-like-a-junior/)
