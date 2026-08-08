---
layout: post
title: "A $100K-Class Missing-Index Post-Mortem"
date: 2025-12-03 23:09:00 +0000
categories: software engineering
tags: [postmortem, fintech, reliability, career]
excerpt_separator: <!--more-->
greeting: "small query, expensive failure chain"
description: "A concrete missing-index post-mortem showing how weak load tests, query review, and observability turn one harmless SQL change into a costly outage."
image:
  url: assets/images/blog/2025-12-03-my-100k-mistake-a-post-mortem-cover.png
  alt: "Financial chart plunging into red on a monitor with somber reflective lighting"
---
A missing index rarely looks dramatic in code review. It is one absent migration beside a query that returns quickly on a developer database.

Under production cardinality, that omission can saturate a connection pool, delay callbacks, and create a six-figure class of operational damage. The useful lesson is not the invented precision of a loss number. It is the failure chain that makes a small SQL mistake expensive.

<!--more-->

## The Query That Looks Harmless

Imagine a reconciliation dashboard for operations. Its query looks harmless.

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

## Where The Cost Comes From

There is rarely one clean invoice. Cost arrives as support work, partner penalties, delayed settlements, emergency engineering, and lost customer trust. That is why "$100K-class" is a severity label here, not a claim about one undocumented incident.

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

## The Review Failure

The author may have omitted the index, but the delivery system still had several chances to catch it. Review did not ask for a query plan. Tests were too mocked. Metrics were late. Staging data had no useful scale.

## Make The Cheap Check Early

TDD is not only unit tests. Architecture safety includes realistic data, integration tests, query plans, observability, and rollback.

Small oversight becomes expensive when system has no guardrails. Build guardrails before invoice arrives.


- [Refactoring Without Tests Is Just Guessing](/blog/refactoring-without-tests-is-just-guessing/)
- [10 Years In Big Tech: The Ugly Truth About Fintech](/blog/10-years-in-big-tech-ugly-truth-about-fintech/)
- [The $1 Million Bug: A Junior's Nightmare](/blog/one-million-dollar-bug-juniors-nightmare/)
