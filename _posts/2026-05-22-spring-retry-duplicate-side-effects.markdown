---
layout: post
title: "Spring Retry Can Duplicate Side Effects: Annotate With Suspicion"
date: 2026-05-22 20:20:00 +0100
categories: software engineering
tags: [spring, retries, idempotency, reliability]
excerpt_separator: <!--more-->
greeting: "a retry repeats the dangerous part too"
description: "Use Spring retry only after classifying transient failures, setting backoff and deadlines, and making every repeated side effect idempotent."
image:
  url: assets/images/blog/2026-05-22-spring-retry-duplicate-side-effects-cover.png
  alt: "A retry loop stamping the same payment twice before an idempotency barrier stops it"
---
`@Retryable` is one annotation away from turning a temporary timeout into duplicate work.

The timeout says you did not receive an answer. It does not say the remote system did nothing.

<!--more-->

## Classify Before Repeating

Retry connection resets, selected timeouts, and explicit temporary responses when the operation is safe. Do not retry validation failures, permission errors, or every `RuntimeException`.

~~~java
@Retryable(
    retryFor = TransientLedgerFailure.class,
    maxAttempts = 3,
    backoff = @Backoff(delay = 100, multiplier = 2, random = true)
)
LedgerEntry create(EntryCommand command) { ... }
~~~

The annotation is the least interesting part. The method needs an idempotency key accepted by the dependency. Without it, a lost success response can create a second entry.

## Budget The Whole Operation

Three attempts with a two-second client timeout plus backoff cannot fit inside a three-second request deadline. Retry code often forgets the caller clock.

Pass a deadline or compute remaining time. Stop before the caller has abandoned the result. Cap backoff and add jitter so many instances do not retry in lockstep.

## Watch Transaction Boundaries

Retrying inside one database transaction may repeat work against a transaction already marked for rollback. Retrying a whole transactional method may repeat inserts unless constraints or keys make them safe.

Test the ambiguous case: dependency performs side effect, response is lost, and caller retries. A happy-path stub proves nothing important.

Measure attempts, final failures, recovered calls, and time spent retrying. If retries hide a dependency outage for ten minutes, your dashboard should still know.

Retry is a failure-handling policy. Treat it as design, not decoration.


- [Idempotency: How Not To Charge A Client Twice](/blog/idempotency-how-not-to-charge-a-client-twice/)
- [The Anatomy Of A Distributed Transaction](/blog/anatomy-of-a-distributed-transaction/)
