---
layout: post
title: "Transaction Isolation Levels: Name The Anomaly You Cannot Accept"
date: 2026-05-29 12:30:00 +0100
categories: software engineering
tags: [database, transactions, isolation, fintech]
excerpt_separator: <!--more-->
greeting: "stronger is not automatically safer"
description: "Choose database transaction isolation by lost updates, write skew, non-repeatable reads, retry policy, and the invariants your use case requires."
image:
  url: assets/images/blog/2026-05-29-transaction-isolation-levels-cover.png
  alt: "Concurrent transactions separated by adjustable isolation walls around one shared invariant"
---
“Use serializable because money” is not a complete design. Neither is “read committed is default, so it must be fine.”

Name the anomaly that can break your invariant, then choose locking, constraints, isolation, and retry behavior together.

<!--more-->

## A Snapshot Can Still Mislead A Decision

Imagine two doctors independently check that at least one doctor remains on call. Each transaction sees two, each removes one, and the final state has zero. Different rows were updated, so a simple row conflict may not catch the cross-row invariant.

This is write skew. The same shape appears in limits, reservations, and approvals.

## Isolation Labels Differ In Detail

SQL names describe broad guarantees, but database implementations differ. Read your database documentation for exact behavior.

PostgreSQL `READ COMMITTED` gives each statement a fresh snapshot. `REPEATABLE READ` keeps a transaction snapshot and can abort conflicting updates. `SERIALIZABLE` adds detection for broader dependency patterns and may abort a transaction that must be retried.

## Retrying Is Part Of Serializable

If your code selects serializable isolation but treats a serialization failure as HTTP 500, the design is incomplete. Retry the whole transaction with bounded attempts, only when its external effects are safe.

Database constraints are often stronger and simpler for local invariants. A unique index can prevent duplicate business keys at any common isolation level.

Do not hold a stronger transaction open across slow network calls. You increase contention and still cannot roll back the remote world.

Draw the reads and writes of concurrent transactions. If you cannot point to the protected invariant, the isolation setting is superstition.


- [Database Locks: The Silent Killer Of High-Load Systems](/blog/database-locks-silent-killer-high-load-systems/)
- [Idempotency: How Not To Charge A Client Twice](/blog/idempotency-how-not-to-charge-a-client-twice/)
