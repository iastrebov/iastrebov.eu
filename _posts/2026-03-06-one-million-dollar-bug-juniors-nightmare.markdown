---
layout: post
title: "The $1 Million Bug: A Junior's Nightmare"
date: 2026-03-06 07:12:00 +0000
categories: software engineering
tags: [fintech, bugs, java, reliability]
excerpt_separator: <!--more-->
greeting: "small bug, large invoice"
description: "A fintech failure scenario showing how nulls and race conditions in account balance logic can become a million-dollar production bug."
image:
  url: assets/images/blog/2026-03-06-one-million-dollar-bug-juniors-nightmare-cover.png
  alt: "Red alarm server rack with a glowing insect-like bug emerging from cracked hardware"
---
A junior ships small change in transaction flow. Tests pass because tests are weak. Production receives rare input. Null appears. Retry logic fires. Balance updates twice.

Now small bug has business number attached. Maybe not exactly $1 million. Maybe more. Enough that nobody cares how clean your code looked.

<!--more-->

## The Bad Code

~~~java
void apply(Transaction tx) {
    Account account = repository.findById(tx.accountId());

    if (tx.type().equals("CREDIT")) {
        account.balance(account.balance().add(tx.amount()));
    } else {
        account.balance(account.balance().subtract(tx.amount()));
    }

    repository.save(account);
}
~~~

Problems everywhere.

Repository may return null. Transaction type may be null. Amount may be negative. Balance update is read-modify-write race. Duplicate transaction can be applied twice. No idempotency. No version check.

This is not code. This is incident seed.

## Exact Failure

Two callbacks for same transaction arrive close together. Both load same balance 100. Both add 50. Both save 150. Or worse, retry after timeout applies again and balance becomes 200.

Maybe reconciliation catches later. Maybe customer withdraws before later. Now finance team has interesting morning.

## Defensive Fix

~~~java
@Transactional
void apply(Transaction tx) {
    Objects.requireNonNull(tx, "transaction");
    if (tx.amount().signum() <= 0) {
        throw new IllegalArgumentException("amount must be positive");
    }

    Account account = repository.findByIdForUpdate(tx.accountId())
        .orElseThrow(() -> new UnknownAccountException(tx.accountId()));

    if (repository.existsApplied(tx.id())) {
        return;
    }

    Money newBalance = switch (tx.type()) {
        case CREDIT -> account.balance().plus(tx.amount());
        case DEBIT -> account.balance().minus(tx.amount());
    };

    account.updateBalance(newBalance);
    repository.markApplied(tx.id());
}
~~~

This is still simplified, but direction is sane: validate, lock or use optimistic version, idempotency key, enum type, transaction boundary.

## Tests That Should Exist

~~~java
@Test
void duplicateTransactionIsIgnored() {
    service.apply(tx("t1", CREDIT, "50.00"));
    service.apply(tx("t1", CREDIT, "50.00"));

    assertThat(accountBalance()).isEqualTo(new Money("150.00"));
}
~~~

Also test unknown account, negative amount, null type, concurrent debit, and insufficient funds.

## Defensive Does Not Mean Paranoid

It means you know where blast radius is. Balance mutation is blast-radius code. Treat it differently from profile avatar update.

Use database constraints. Use unique index on applied transaction id. Use transaction isolation intentionally. Log decisions with correlation id. Monitor mismatch.

## Junior Nightmare Lesson

The bug was not NullPointerException. The bug was lack of defensive thinking around money flow.

Null just opened door.

## Final Rule

Financial code must assume retries, duplicates, partial failures, and weird input. If your happy-path method cannot survive that, it is not production code yet.

## Related reading

- [Refactoring Without Tests Is Just Guessing](/blog/refactoring-without-tests-is-just-guessing/)
- [How To Read Documentation Like A Senior Engineer](/blog/how-to-read-documentation-like-a-senior-engineer/)
