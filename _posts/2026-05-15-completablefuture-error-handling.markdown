---
layout: post
title: "CompletableFuture Error Handling: The Exception Is Still There"
date: 2026-05-15 21:10:00 +0100
categories: software engineering
tags: [java, completablefuture, concurrency, reliability]
excerpt_separator: <!--more-->
greeting: "async syntax does not cancel failure"
description: "Handle CompletableFuture failures without swallowing causes, duplicating side effects, leaking work, or returning partial results by accident."
image:
  url: assets/images/blog/2026-05-15-completablefuture-error-handling-cover.png
  alt: "Branching asynchronous paths carrying one visible red failure back to their parent"
---
`CompletableFuture` moves work away from the current call stack. It does not move responsibility away with it.

Most bad future code fails in one of two directions: it hides an exception and returns a fake fallback, or it lets sibling work continue after the request has already failed.

<!--more-->

## CompletionException Is Packaging

`join()` throws an unchecked `CompletionException`; `get()` uses checked `ExecutionException` and also handles interruption. Both wrap the original failure.

Do not log only the wrapper message.

~~~java
try {
    return quoteFuture.join();
} catch (CompletionException failure) {
    Throwable cause = failure.getCause();
    throw new QuoteUnavailable("quote calculation failed", cause);
}
~~~

Translate once at a boundary and preserve the cause.

## exceptionally Can Hide An Outage

~~~java
return riskClient.check(customer)
    .exceptionally(failure -> RiskResult.approved());
~~~

This code converts every timeout, parsing bug, authentication error, and programming defect into approval. It is concise. It is also a business policy, probably the wrong one.

Fallbacks must be narrow. Inspect the cause, decide which failures are expected, emit a metric, and make the degraded result visible.

## handle Changes Both Paths

`handle` receives either a value or a failure and always creates a new outcome. Use it when both paths genuinely need transformation. Use `whenComplete` for observation that must not replace the result.

~~~java
future.whenComplete((value, failure) -> {
    if (failure != null) {
        metrics.increment("quote.failure");
    }
});
~~~

Be careful: the callback itself can throw and alter the completion chain. Observability code should not invent a second outage.

## Cancellation Is Not A Workflow

Cancelling a `CompletableFuture` does not guarantee underlying remote work stops. A client library may ignore interruption; a request may already have reached provider. Timeouts also do not compensate side effects.

For independent read calls, define deadlines and decide whether a partial response is valid. For writes, use idempotency and a durable state machine. An async API cannot create transactional semantics from syntax.

## Name The Executor

Async stages without an explicit executor may use the common pool. Blocking work there can interfere with unrelated tasks. Pass an executor whose capacity and ownership match the workload, then expose queue and rejection metrics.

Modern structured-concurrency APIs can express request-scoped fan-out more directly, especially cancellation and lifetime. Existing code still uses `CompletableFuture` everywhere, so understanding its failure semantics remains useful.


- [Master Structured Concurrency In Java 25](/blog/master-structured-concurrency-in-java-25/)
- [Idempotency: How Not To Charge A Client Twice](/blog/idempotency-how-not-to-charge-a-client-twice/)
