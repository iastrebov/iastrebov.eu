---
layout: post
title: "EXPLAIN ANALYZE: Read The PostgreSQL Plan Without Guessing"
date: 2026-05-27 18:40:00 +0100
categories: software engineering
tags: [postgresql, explain, sql, performance]
excerpt_separator: <!--more-->
greeting: "estimated rows tell a story"
description: "Read PostgreSQL EXPLAIN ANALYZE through row estimates, loops, buffers, scan choices, and timing without optimizing the prettiest node."
image:
  url: assets/images/blog/2026-05-27-postgresql-explain-analyze-cover.png
  alt: "A PostgreSQL query plan tree revealing one oversized branch with wrong row estimates"
---
The slowest-looking node in a query plan is not always the root cause. A bad row estimate near the bottom can make the planner choose the wrong join and multiply work above it.

<!--more-->

## Use ANALYZE With Respect

`EXPLAIN` estimates. `EXPLAIN ANALYZE` executes. On a write statement, that means real writes unless you wrap it in a transaction and roll back safely. Do not learn this on production data.

For reads, start with:

~~~sql
explain (analyze, buffers, format text)
select ...;
~~~

Buffers show whether work came from shared cache or storage. Timing adds overhead, so treat it as evidence, not laboratory purity.

## Compare Estimated And Actual Rows

If a node estimates 10 rows and returns 500,000, statistics or data correlation are misleading the planner. Running `ANALYZE`, increasing statistics for a skewed column, or using extended statistics may help. Adding random indexes may not.

Multiply `actual rows` by `loops`. A fast inner node executed one million times can dominate the query.

## Scan Names Are Not Moral Labels

A sequential scan is correct when much of a table is needed. An index scan can be worse when it performs many random heap reads. “Seq Scan” is not automatic bug.

Look at total work, filters removing many rows late, sorts spilling to disk, repeated loops, and join input sizes. Then rewrite or index the access path that causes that work.

Capture the query with representative parameters. A plan for one tiny merchant can differ from a merchant holding half the table. Performance lives in distributions, not one sanitized example.


- [PostgreSQL Index Column Order: The Left Edge Decides](/blog/postgresql-index-column-order/)
- [Database Locks: The Silent Killer Of High-Load Systems](/blog/database-locks-silent-killer-high-load-systems/)
