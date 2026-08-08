---
layout: post
title: "Fast Testcontainers: Reuse Infrastructure, Reset State"
date: 2026-07-01 15:05:00 +0100
categories: software engineering
tags: [testing, testcontainers, database, java]
excerpt_separator: <!--more-->
greeting: "real dependencies need disciplined lifecycle"
description: "Speed up Testcontainers suites with shared container lifecycles, isolated schemas, bounded context startup, and deterministic state cleanup."
image:
  url: assets/images/blog/2026-07-01-testcontainers-speed-cover.png
  alt: "One reusable database container serving many isolated test compartments"
---
Starting PostgreSQL for every test method is realistic and unnecessarily slow. Sharing one dirty database across the whole suite is fast and unreliable.

The useful middle is shared infrastructure with isolated state.

<!--more-->

## Separate Process From Data

Start a container once per test class or suite boundary supported by your framework. Reset tables, schemas, or databases between tests using a method whose cost you measured.

Transactions that roll back are fast but do not cover code committing in another thread or connection. Truncation is explicit but must respect foreign keys. Per-test schemas improve isolation and add setup work.

## Avoid Full Context By Habit

Repository tests need database wiring, not every HTTP client and scheduler. Slice application context or wire the adapter directly.

Pin dependency versions, run migrations as production does, and expose container logs on failure. A fast fake database teaches wrong SQL faster.

Parallel execution changes the lifecycle calculation. A shared container can serve concurrent tests only when their database names, schemas, users, or key spaces cannot collide. Measure contention as well as startup time; one reused dependency can become a serial bottleneck that makes the suite slower.

Optimize suite by profiling startup and cleanup, not by replacing the risky dependency with Mockito.

## Choosing The Test Boundary

- [Mockito Is Not A Testing Strategy](/blog/why-i-ban-mockito-in-my-teams/)
- [The Test Pyramid Is A Cost Model, Not A Quota](/blog/test-pyramid-risk-model/)
