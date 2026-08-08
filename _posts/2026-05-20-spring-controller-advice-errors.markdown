---
layout: post
title: "Spring ControllerAdvice: Stable Errors Without A Catch-All Mess"
date: 2026-05-20 07:25:00 +0100
categories: software engineering
tags: [spring, api-design, errors, java]
excerpt_separator: <!--more-->
greeting: "error payloads are contracts"
description: "Build stable Spring API error responses with ControllerAdvice, specific mappings, correlation IDs, and no stack-trace leakage."
image:
  url: assets/images/blog/2026-05-20-spring-controller-advice-errors-cover.png
  alt: "Different backend failures translated into clean stable API response cards"
---
An exception handler that returns `{ "message": "something went wrong" }` for every failure has centralized code and decentralized confusion.

Clients need stable categories. Operators need the real cause. These are different outputs.

<!--more-->

## Define A Small Public Shape

~~~java
record ApiProblem(
    String code,
    String message,
    String correlationId,
    Map<String, String> fields
) {}
~~~

The code is for client logic. The message is for a human. A correlation ID connects the response to internal telemetry. Field errors belong only where they make sense.

Do not expose exception class names, SQL, stack traces, internal URLs, or dependency payloads.

## Map Specific Failure Families

Use explicit handlers for validation, missing resources, state conflicts, and unavailable dependencies. Keep the unexpected fallback narrow and loud.

~~~java
@ExceptionHandler(UnknownAccount.class)
ResponseEntity<ApiProblem> notFound(UnknownAccount failure) {
    return problem(HttpStatus.NOT_FOUND, "ACCOUNT_NOT_FOUND", failure.safeMessage());
}
~~~

An unexpected `NullPointerException` should not be translated into 404 because it happened while loading an account.

## Log Once At The Owning Boundary

Client mistakes usually need metrics, not error stack traces. Unexpected failures need the cause and request context in internal logs. Avoid logging the same exception in repository, service, controller, and global handler; four stack traces do not create four times more evidence.

Test response status, code, and safe fields. Treat changes as API evolution. Renaming `ACCOUNT_NOT_FOUND` can break a client even when JSON still parses.

A stable error contract makes failure boring. That is exactly what an API should do.


- [Java Exception Design: Stop Turning Every Failure Into 500](/blog/java-exception-design/)
- [Your API Is A Mess: 5 Rules For Backward Compatibility](/blog/your-api-is-a-mess-5-rules-for-backward-compatibility/)
