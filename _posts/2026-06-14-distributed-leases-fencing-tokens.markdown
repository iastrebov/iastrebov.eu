---
layout: post
title: "Distributed Leases Need Fencing Tokens, Not Hope"
date: 2026-06-14 14:30:00 +0100
categories: software engineering
tags: [distributed-systems, locking, leases, concurrency]
excerpt_separator: <!--more-->
greeting: "an expired owner can still be running"
description: "Protect distributed lease workflows with ownership, expiry, monotonic fencing tokens, and resource-side rejection of stale workers."
image:
  url: assets/images/blog/2026-06-14-distributed-leases-fencing-tokens-cover.png
  alt: "An expired worker blocked by a newer numbered fencing token at a shared resource"
---
A worker acquires a lease, pauses for a long garbage collection, and wakes after the lease expired. Another worker already owns the job. Both now believe they may write.

Lease expiry alone cannot stop the old process from continuing.

<!--more-->

## Add A Monotonic Token

Each successful acquisition receives a higher fencing number: 41, then 42. Every write to the protected resource includes the token. The resource rejects a token older than the latest accepted one.

~~~sql
update job_output
set value = :value, fence = :fence
where id = :id and fence < :fence;
~~~

Now worker 41 cannot overwrite work from worker 42 even if it wakes late.

## Ownership Checks Still Matter

Renew and release only when lease ID and owner match. A timed-out release request from an old owner must not clear a new lease.

Clock assumptions also belong in protocol. Prefer expiry evaluated by the lease store instead of comparing unrelated machine clocks where possible.

If the protected resource cannot validate a fencing token, the lease offers weaker exclusion. Understand that boundary before using it for money or irreversible effects.

Distributed locks are not larger mutexes. Pauses, network partitions, and stale owners make them protocols. Tokens turn one dangerous assumption into a check the resource can enforce.


- [Spring Scheduled Jobs: One Cron, Three Instances, Triple Work](/blog/spring-scheduled-job-overlap/)
- [Database Locks: The Silent Killer Of High-Load Systems](/blog/database-locks-silent-killer-high-load-systems/)
