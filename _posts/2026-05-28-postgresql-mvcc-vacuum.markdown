---
layout: post
title: "PostgreSQL MVCC And Vacuum: Dead Rows Are Still Work"
date: 2026-05-28 06:45:00 +0100
categories: software engineering
tags: [postgresql, mvcc, vacuum, database]
excerpt_separator: <!--more-->
greeting: "updates leave versions behind"
description: "Understand PostgreSQL MVCC, dead tuples, long transactions, vacuum progress, and why table bloat is usually an application story too."
image:
  url: assets/images/blog/2026-05-28-postgresql-mvcc-vacuum-cover.png
  alt: "A vacuum mechanism clearing obsolete row versions while one long transaction holds a gate open"
---
PostgreSQL often updates a row by creating a new version. Old versions remain visible to transactions whose snapshot still needs them. Later, vacuum makes obsolete space reusable.

This is why an update-heavy table can grow even when row count stays flat.

<!--more-->

## Long Transactions Hold History

A transaction left open for hours can keep old row versions visible and prevent cleanup. The culprit may be an abandoned admin session, a batch job reading slowly, or application code that performs network calls inside a transaction.

Monitor transaction age, not only query duration. An idle transaction can be quiet and still expensive.

## Vacuum Is Maintenance, Not Magic Shrink

Regular vacuum usually marks space reusable inside the table. It does not necessarily return file size to the operating system. Aggressive rewrite operations have different locking and capacity costs.

Autovacuum thresholds that work for a large stable table may react too slowly to a small table changing constantly. Observe dead tuples, vacuum timestamps, table growth, and workload before tuning global parameters.

## Indexes Accumulate Work Too

Updates can create index churn. HOT updates help when indexed columns do not change and page space allows it, but schema and fill pattern matter. Ten unnecessary indexes make every row change heavier.

The useful investigation crosses layers: which endpoint updates the row, how long its transaction lives, which columns change, how frequently autovacuum runs, and whether queries still estimate cardinality correctly.

Vacuum problems are rarely solved by one heroic manual command. Short transactions and observable maintenance are the boring durable fix.


- [Database Connection Pool Sizing: More Connections Can Make You Slower](/blog/database-connection-pool-sizing/)
- [Database Locks: The Silent Killer Of High-Load Systems](/blog/database-locks-silent-killer-high-load-systems/)
