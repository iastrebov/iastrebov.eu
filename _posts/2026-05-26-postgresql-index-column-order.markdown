---
layout: post
title: "PostgreSQL Index Column Order: The Left Edge Decides"
date: 2026-05-26 08:15:00 +0100
categories: software engineering
tags: [postgresql, indexes, sql, performance]
excerpt_separator: <!--more-->
greeting: "one index is not every query"
description: "Choose PostgreSQL multicolumn index order from equality, range, sorting, and selectivity instead of copying WHERE clause order."
image:
  url: assets/images/blog/2026-05-26-postgresql-index-column-order-cover.png
  alt: "A sorted multicolumn index staircase whose left edge unlocks the remaining columns"
---
An index on `(merchant_id, status, created_at)` is not three independent indexes glued together. It is one ordered structure, and the leftmost usable prefix controls how narrowly PostgreSQL can navigate it.

<!--more-->

## Equality Before Range Is A Useful Start

For this query:

~~~sql
select id, amount
from payments
where merchant_id = $1
  and status = 'PENDING'
  and created_at >= $2
order by created_at;
~~~

`(merchant_id, status, created_at)` is a sensible candidate: two equality conditions narrow the tree before the range and ordering column.

Change the workload and the answer changes. A query filtering only `status` may need to scan much of an index beginning with `merchant_id`. PostgreSQL 18 can use [B-tree skip scan](https://www.postgresql.org/docs/18/indexes-multicolumn.html) when the omitted leading column has few distinct values. Verify the actual plan instead of treating the leftmost-prefix rule as absolute. A low-cardinality status may also be poor standalone key.

## Query Order Is Not Index Order

Rearranging predicates in SQL does not change semantics or force index navigation order. Design from access patterns, not visual order of the `WHERE` clause.

Include columns can support index-only scans without making those columns part of search order:

~~~sql
create index payments_pending_lookup
on payments (merchant_id, status, created_at)
include (id, amount);
~~~

That improves one read shape but increases index size and write cost.

## Partial Indexes Need Stable Predicates

If pending rows are a small stable subset, a partial index may be better:

~~~sql
create index payments_pending_by_merchant
on payments (merchant_id, created_at)
where status = 'PENDING';
~~~

The query predicate must imply the index predicate. Verify with `EXPLAIN`, real parameter patterns, and production-like statistics.

Every extra index slows inserts and updates. Build the smallest set that serves real queries, then watch usage before collecting indexes like badges.


- [Stop Using ORMs Like A Junior](/blog/stop-using-orms-like-a-junior/)
- [A $100K-Class Missing-Index Post-Mortem](/blog/my-100k-mistake-a-post-mortem/)
