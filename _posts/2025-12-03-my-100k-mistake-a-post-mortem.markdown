---
layout: post
title: "My $100K Mistake: A Post-Mortem"
date: 2025-12-03 23:09:00 +0000
categories: software engineering
tags: [postmortem, fintech, reliability, career]
excerpt_separator: <!--more-->
greeting: "small oversight, expensive lesson"
description: "A realistic post-mortem story about a costly missing-index outage and the TDD, observability, and architecture lessons it taught."
image:
  url: assets/images/blog/2025-12-03-my-100k-mistake-a-post-mortem-cover.png
  alt: "Financial chart plunging into red on a monitor with somber reflective lighting"
---
This story is anonymized, but lesson is real: tiny database oversight can create invoice with too many zeros.

We shipped feature. It worked in staging. It passed happy-path tests. Then production traffic arrived and one missing index turned simple query into financial bruise.

<!--more-->

## The Change

We added reconciliation dashboard for operations. Query looked harmless.

~~~sql
select *
from transactions
where merchant_id = ?
  and status = 'PENDING'
order by created_at desc
limit 100;
~~~

Staging had small data. Production had years. No composite index for <code>merchant_id, status, created_at</code>.

Under load, database scanned too much, connection pool filled, API latency spiked, payment callbacks delayed, support queue exploded.

## The Cost

Not one clean number. Lost staff time, partner penalties, delayed settlements, emergency engineering, and customer trust. Round it mentally to $100K class mistake.

Nobody cared that query was readable.

## What We Missed

We tested controller. We mocked repository. We did not run query against production-like volume. We did not inspect query plan in review. Alert on database saturation was too slow.

Classic chain: one small technical miss plus weak safety net.

## Proper Test

~~~java
@Test
void pendingTransactionsQueryUsesExpectedIndex() {
    jdbc.execute("explain analyze select * from transactions where merchant_id = 'm1' and status = 'PENDING' order by created_at desc limit 100");
    // In real project assert plan shape or keep this as reviewed migration test output.
}
~~~

Better: migration checklist requires <code>EXPLAIN</code> for new query on large table.

## Architectural Lesson

Operational dashboard should not run heavy ad hoc queries on primary payment database during peak time.

Use read replica, projection table, async materialization, or at least strict indexes and rate limits.

## Cultural Lesson

The mistake was mine because I touched it. It was ours because process allowed it.

Reviewer did not ask plan. Tests were too mocked. Metrics were late. Staging data lied.

## Final Lesson

TDD is not only unit tests. Architecture safety includes realistic data, integration tests, query plans, observability, and rollback.

Small oversight becomes expensive when system has no guardrails. Build guardrails before invoice arrives.

## Related reading

- [Refactoring Without Tests Is Just Guessing](/blog/refactoring-without-tests-is-just-guessing/)
- [10 Years In Big Tech: The Ugly Truth About Fintech](/blog/10-years-in-big-tech-ugly-truth-about-fintech/)
- [The $1 Million Bug: A Junior's Nightmare](/blog/one-million-dollar-bug-juniors-nightmare/)
