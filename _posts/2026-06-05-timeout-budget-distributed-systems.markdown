---
layout: post
title: "Timeout Budgets: Your 200 ms Service Cannot Make Three 200 ms Calls"
date: 2026-06-05 08:20:00 +0100
categories: software engineering
tags: [distributed-systems, timeouts, latency, reliability]
excerpt_separator: <!--more-->
greeting: "deadlines must travel downstream"
description: "Design timeout budgets across service calls, connection pools, retries, and queues so abandoned work stops before the caller gives up."
image:
  url: assets/images/blog/2026-06-05-timeout-budget-distributed-systems-cover.png
  alt: "One request deadline divided across several downstream service timers"
---
A 200 ms endpoint that calls three dependencies with 200 ms timeouts has no budget. It has three separate wishes.

Timeouts must fit inside one end-to-end deadline, including queueing, serialization, connection acquisition, retries, and response work.

<!--more-->

## Carry Remaining Time

Set a deadline when the request enters. Before each call, calculate remaining time and reserve enough for local cleanup and response.

~~~java
Duration remaining = Duration.between(clock.instant(), deadline);
if (remaining.compareTo(MINIMUM_LEDGER_BUDGET) < 0) {
    throw new DeadlineExceeded();
}
ledger.fetch(id, remaining.minus(RESPONSE_RESERVE));
~~~

A fixed timeout deep in a client library ignores time already spent upstream.

## Queueing Spends Budget Too

Waiting for a thread, connection, rate limiter, or executor slot is real latency. If acquisition can wait longer than the request deadline, work may begin after nobody wants its answer.

Retries consume the same budget. The second attempt is useful only if enough time remains to complete it and the operation is safe to repeat.

## Cancel What Lost Relevance

Caller cancellation should propagate where protocols and libraries allow it. Cancellation cannot undo a remote side effect already accepted, so writes still need idempotency and recovery.

Measure time by stage and classify timeout ownership. “Downstream timeout” means little if 180 ms was already lost in local queue.

A deadline is one budget shared by the whole call graph. Treat it like money: every layer must account for what it spends.


- [CompletableFuture Error Handling: The Exception Is Still There](/blog/completablefuture-error-handling/)
- [Spring Retry Can Duplicate Side Effects: Annotate With Suspicion](/blog/spring-retry-duplicate-side-effects/)
