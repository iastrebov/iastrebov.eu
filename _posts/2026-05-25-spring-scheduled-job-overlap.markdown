---
layout: post
title: "Spring Scheduled Jobs: One Cron, Three Instances, Triple Work"
date: 2026-05-25 22:15:00 +0100
categories: software engineering
tags: [spring, scheduling, concurrency, reliability]
excerpt_separator: <!--more-->
greeting: "the cluster also reads your cron"
description: "Prevent overlapping Spring scheduled jobs with idempotent work claims, database leases, bounded batches, and metrics that expose stuck runs."
image:
  url: assets/images/blog/2026-05-25-spring-scheduled-job-overlap-cover.png
  alt: "Three service clocks triggering the same job while a durable lease admits only one"
---
`@Scheduled` means the method runs in each application instance. Deploy three replicas and you may run the same job three times.

Sometimes that is useful partitioning. Usually it is an expensive surprise.

<!--more-->

## First Make The Work Repeatable

A distributed lock prevents overlap only while the lock works. The job still needs idempotent item processing because a process can crash after side effect and before progress is recorded.

Claim work in small batches with a durable state transition:

~~~sql
update payouts
set status = 'PROCESSING', worker_id = :worker
where id in (
    select id from payouts
    where status = 'PENDING'
    order by id
    for update skip locked
    limit 100
)
returning *;
~~~

Multiple workers can cooperate without choosing the same rows. Exact syntax and lock behavior must match your database.

## A Lease Needs Expiry And Ownership

For a singleton job, use a database or coordination-service lease with an owner ID and expiry. Renew while work runs. Release only if you still own it.

A boolean `locked` column without expiry turns one crash into permanent silence. A fixed expiry shorter than job duration allows overlap. Time and ownership are part of the lock protocol.

## Fixed Rate Can Pile Up

Decide whether the next run starts relative to previous start or completion. If work normally takes eight minutes, a five-minute schedule is capacity bug written as annotation.

Expose last successful completion, duration, claimed item count, failure count, and oldest pending item. Alert on missed business outcome, not only thrown exception.

Cron is trigger. The job is a distributed workflow. Design it with same suspicion as any other concurrent system.


- [Database Locks: The Silent Killer Of High-Load Systems](/blog/database-locks-silent-killer-high-load-systems/)
- [Idempotency: How Not To Charge A Client Twice](/blog/idempotency-how-not-to-charge-a-client-twice/)
