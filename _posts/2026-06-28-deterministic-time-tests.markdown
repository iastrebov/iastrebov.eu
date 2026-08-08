---
layout: post
title: "Deterministic Time Tests: Stop Sleeping And Inject A Clock"
date: 2026-06-28 12:55:00 +0100
categories: software engineering
tags: [testing, time, java, reliability]
excerpt_separator: <!--more-->
greeting: "waiting is not an assertion"
description: "Make Java time tests deterministic with injected clocks, explicit zones, controllable schedulers, and no Thread.sleep timing guesses."
image:
  url: assets/images/blog/2026-06-28-deterministic-time-tests-cover.png
  alt: "A test harness controlling a precise clock while unreliable sleep timers are disconnected"
---
`Thread.sleep(1000)` does not prove a timeout. It proves the test machine waited roughly one second and you hope scheduling behaved.

<!--more-->

## Inject Wall Time

~~~java
final class TokenPolicy {
    private final Clock clock;

    boolean expired(Instant expiresAt) {
        return !clock.instant().isBefore(expiresAt);
    }
}
~~~

Tests use `Clock.fixed` and choose instants exactly before, at, and after expiry. Production uses a system clock with an explicit zone.

## Control Scheduled Work

For retry delay or scheduler logic, test the policy separately from real waiting. A fake scheduler or virtual-time facility can advance pending tasks deterministically.

One integration test may still verify real framework wiring, but hundreds of sleeps create slow flaky suite.

Test daylight-saving boundaries when local business time matters. A fixed UTC noon test cannot cover a missing local hour.

Keep monotonic duration separate from wall-clock time. Deadlines and elapsed-time measurements should not become negative when the system clock adjusts. The injected abstraction may therefore expose a wall clock for business timestamps and a monotonic ticker for measuring intervals.

If a timing test fails only on busy CI, remove the timing guess. The CI machine is revealing design, not misbehaving personally.

## Time At Other Boundaries

- [PostgreSQL timestamptz: Store Instants, Name Business Zones](/blog/postgresql-timestamptz-timezones/)
- [Spring Scheduled Jobs: One Cron, Three Instances, Triple Work](/blog/spring-scheduled-job-overlap/)
