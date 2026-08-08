---
layout: post
title: "Java Exception Design: Stop Turning Every Failure Into 500"
date: 2026-05-09 12:05:00 +0100
categories: software engineering
tags: [java, exceptions, api-design, reliability]
excerpt_separator: <!--more-->
greeting: "failures have different owners"
description: "Design Java exceptions by failure meaning, preserve useful causes, and map domain, client, dependency, and programming errors deliberately."
image:
  url: assets/images/blog/2026-05-09-java-exception-design-cover.png
  alt: "Colored failure signals sorted into distinct channels instead of one red alarm"
---
A validation error, a missing account, a provider timeout, and a broken invariant are not four spellings of `RuntimeException`. They have different owners and different recovery paths.

Flatten them into one generic exception and your API returns 500 for everything. Clients retry bad requests. Operators chase user mistakes. Useful context dies in logs.

<!--more-->

## Start With Failure Meaning

A practical service usually has several families:

- input is invalid;
- requested resource does not exist;
- current state rejects the operation;
- dependency is temporarily unavailable;
- code violated an invariant.

Name exceptions after these meanings, not after the layer that happened to notice them.

~~~java
sealed class TransferFailure extends RuntimeException
        permits InvalidTransfer, TransferConflict, LedgerUnavailable {
    TransferFailure(String message, Throwable cause) {
        super(message, cause);
    }
}
~~~

You do not need a sealed hierarchy in every project. You do need a vocabulary that prevents `catch (Exception)` from becoming business logic.

## Translate At Boundaries

Low-level failures should not leak through every layer, but translation must keep the cause.

~~~java
try {
    return ledgerClient.reserve(command);
} catch (HttpTimeoutException timeout) {
    throw new LedgerUnavailable("ledger reservation timed out", timeout);
}
~~~

Now the domain-facing service knows the dependency is unavailable, while the stack trace still knows why.

Do not wrap an exception five times with messages that add no information. One translation at a meaningful boundary is enough.

## Map Responses In One Place

A controller advice can map stable failure types to stable HTTP responses. Keep stack traces out of client payloads and keep a machine-readable error code.

~~~java
@ExceptionHandler(TransferConflict.class)
ResponseEntity<ApiProblem> conflict(TransferConflict failure) {
    return ResponseEntity.status(409).body(
        new ApiProblem("TRANSFER_CONFLICT", failure.getMessage()));
}
~~~

The log level should follow ownership. Invalid client input is usually not an error page for the on-call engineer. An invariant violation is.

## Checked Or Unchecked Is Secondary

Checked exceptions can document a recoverable outcome, but they also spread mechanical declarations through layers. Unchecked exceptions reduce noise, but they can hide important paths.

Choose per codebase. The larger mistake is using type system with no recovery policy. If a caller cannot do anything except propagate, forcing a catch often creates fake handling.

## Never Catch What You Cannot Repair

This is not resilience:

~~~java
try {
    process(command);
} catch (Exception ignored) {
    return Result.ok();
}
~~~

It converts evidence into corruption. Catch to retry a known transient failure, add context, compensate, map a boundary response, or release a resource. Otherwise let the failure reach the component that owns it.

Exception design is a routing table for responsibility. Build it with same care as an API schema.


- [Your API Is A Mess: 5 Rules For Backward Compatibility](/blog/your-api-is-a-mess-5-rules-for-backward-compatibility/)
- [Log Like Your Job Depends On It Because It Does](/blog/log-like-your-job-depends-on-it-because-it-does/)
