---
layout: post
title: "Circuit Breakers: A Failure Policy, Not A Resilience Sticker"
date: 2026-06-07 09:10:00 +0100
categories: software engineering
tags: [distributed-systems, circuit-breaker, reliability, architecture]
excerpt_separator: <!--more-->
greeting: "stop calling what cannot answer"
description: "Configure circuit breakers from failure classes, sample size, recovery probes, and fallback semantics without hiding dependency outages."
image:
  url: assets/images/blog/2026-06-07-circuit-breaker-failure-policy-cover.png
  alt: "A circuit breaker opening a protected path while a dependency burns behind it"
---
A circuit breaker does not heal a dependency. It stops spending caller time and local resources on a dependency that is unlikely to answer.

That promise is useful only when the breaker counts the right failures.

<!--more-->

## Do Not Count Client Errors

A 400 response proves the dependency is available enough to reject your request. Authentication failure may require escalation, not an open circuit. Timeouts, connection failures, and selected 5xx responses are more plausible health signals.

Define slow calls too. A dependency returning success after your deadline is operationally failing your path.

## Small Windows Flap

Two failures out of three calls can open a breaker on meaningless evidence. Large windows react slowly. Choose minimum call count, time or count window, threshold, and open duration from actual traffic.

Half-open probes need a limit. Allowing all queued callers through at once is not a probe; it is another load test.

## Fallbacks Are Product Decisions

Returning stale catalog data may be fine. Approving a payment because risk service is unavailable is different category. Do not bury fail-open versus fail-closed policy inside infrastructure configuration.

Track breaker state transitions, rejected calls, underlying failures, and fallback usage. If dashboards show only successful fallback responses, an outage becomes invisible.


- [Timeout Budgets: Your 200 ms Service Cannot Make Three 200 ms Calls](/blog/timeout-budget-distributed-systems/)
- [Microservices Are Not A Silver Bullet: You Probably Need A Monolith](/blog/microservices-are-not-a-silver-bullet/)
