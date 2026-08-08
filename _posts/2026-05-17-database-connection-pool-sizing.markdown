---
layout: post
title: "Database Connection Pool Sizing: More Connections Can Make You Slower"
date: 2026-05-17 08:50:00 +0100
categories: software engineering
tags: [database, connection-pool, performance, spring]
excerpt_separator: <!--more-->
greeting: "a queue with sockets is still a queue"
description: "Size a database connection pool from workload and database capacity, then observe wait time, hold time, saturation, and timeout behavior."
image:
  url: assets/images/blog/2026-05-17-database-connection-pool-sizing-cover.png
  alt: "Too many pipes forcing traffic into a narrow database engine until pressure rises"
---
When requests wait for a database connection, raising pool size feels obvious. Sometimes it helps. Sometimes it lets more queries compete for the same CPU and disks, so every query becomes slower.

The pool is admission control, not a performance generator.

<!--more-->

## Measure Two Different Times

Connection acquisition time tells how long a request waited for a slot. Connection usage time tells how long code held that slot.

If acquisition rises while usage remains stable, demand exceeds pool capacity. If usage rises first, the cause is probably slow SQL, locks, network delay, or a transaction doing unrelated work.

These graphs need percentiles. Averages hide the few requests that exhaust your timeout budget.

## Start From Database Capacity

The application does not own the database alone. Count pools across replicas, batch jobs, admin tools, and other services. Leave operational headroom.

A rough throughput relationship is useful:

~~~text
concurrent connections ≈ target database throughput × average hold time
~~~

It is a starting estimate, not sacred formula. Validate under realistic queries.

## Keep Transactions Short

This pattern wastes a scarce connection:

~~~java
@Transactional
void createInvoice(Command command) {
    Invoice invoice = repository.insert(command);
    taxProvider.calculate(invoice); // remote call while connection may be held
    repository.markReady(invoice.id());
}
~~~

Separate durable local steps from remote work. A larger pool only makes the mistake survive longer before saturation.

## Backpressure Beats Infinite Waiting

Set an acquisition timeout below the request deadline. Reject or degrade intentionally when capacity is exhausted. A queue that waits longer than the caller will wait is just memory occupied by dead work.

Track active, idle, pending, timeout count, transaction duration, and database-side sessions. Tune one service while watching database CPU and latency. A green pool dashboard beside a red database dashboard is not success.


- [Database Locks: The Silent Killer Of High-Load Systems](/blog/database-locks-silent-killer-high-load-systems/)
- [Stop Using ORMs Like A Junior](/blog/stop-using-orms-like-a-junior/)
