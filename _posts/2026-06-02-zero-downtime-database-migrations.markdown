---
layout: post
title: "Zero-Downtime Database Migrations: Expand Before You Contract"
date: 2026-06-02 07:10:00 +0100
categories: software engineering
tags: [database, migrations, deployment, reliability]
excerpt_separator: <!--more-->
greeting: "old and new code overlap"
description: "Deploy database changes safely with expand-contract sequencing, online indexes, bounded backfills, compatibility windows, and rollback plans."
image:
  url: assets/images/blog/2026-06-02-zero-downtime-database-migrations-cover.png
  alt: "A database bridge widened under live traffic before the old lane is removed"
---
During a rolling deployment, old and new application versions run at the same time. A migration safe for one version can break the other before rollout reaches 20 percent.

<!--more-->

## Expand

Add the new nullable column, table, or compatible index first. Deploy code that can read old state and write enough information for both representations.

Avoid a table rewrite or long blocking lock without measuring on production-size data. PostgreSQL concurrent index creation, for example, changes locking trade-offs but also has operational rules and failure states to monitor.

## Backfill In Batches

Update a bounded number of rows, commit, pause if necessary, and expose progress. One giant transaction creates locks, WAL volume, replica lag, and rollback pain.

Make the backfill restartable. Store progress or select remaining rows by a stable predicate.

## Switch Reads, Then Contract

After data is complete and new code is fully deployed, switch reads. Observe. Remove old writes later. Drop old columns or constraints in a separate release after the compatibility window closes.

Rollback is easiest during expansion because both shapes still exist. Contracting early converts rollback into archaeology.

Migration files are production code. Review lock behavior, duration, disk requirements, replica impact, and failure recovery, not only final schema.


- [Your API Is A Mess: 5 Rules For Backward Compatibility](/blog/your-api-is-a-mess-5-rules-for-backward-compatibility/)
- [The Works On My Machine Excuse Ends Here](/blog/works-on-my-machine-excuse-ends-here/)
