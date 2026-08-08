---
layout: post
title: "HTTP 202 Accepted: Give Long Jobs A Resource, Not A Promise"
date: 2026-06-24 10:50:00 +0100
categories: software engineering
tags: [http, async, api-design, jobs]
excerpt_separator: <!--more-->
greeting: "accepted is not completed"
description: "Design HTTP 202 asynchronous APIs with job resources, idempotent submission, observable states, cancellation policy, and result retention."
image:
  url: assets/images/blog/2026-06-24-http-202-async-api-cover.png
  alt: "An accepted request becoming a durable job resource with visible state transitions"
---
`202 Accepted` means the server accepted a request for processing. It does not mean the export finished, the payment settled, or the job will definitely succeed.

Return something the client can observe.

<!--more-->

## Create A Job Resource

~~~http
HTTP/1.1 202 Accepted
Location: /jobs/8f3a
Retry-After: 3
~~~

The job representation can move through `QUEUED`, `RUNNING`, `SUCCEEDED`, `FAILED`, and perhaps `CANCELLED`. Include progress only when it is meaningful, not a random percentage animated for comfort.

## Submission Still Needs Idempotency

A client can lose the 202 response and submit again. Use an idempotency key or client operation ID so one logical request creates one job.

Persist job state before returning. An in-memory future behind a durable-looking URL is fraud after restart.

## Define Result And Expiry

On success, link the result or redirect to the created resource. On failure, return a stable problem representation. Document how long job status and result remain available.

Cancellation is a request, not time travel. A job may already have crossed an irreversible boundary. Expose `CANCEL_REQUESTED` or a conflict when immediate cancellation cannot be guaranteed.

Async APIs move waiting out of one connection. They do not remove workflow design.


- [Spring Scheduled Jobs: One Cron, Three Instances, Triple Work](/blog/spring-scheduled-job-overlap/)
- [The Anatomy Of A Distributed Transaction](/blog/anatomy-of-a-distributed-transaction/)
