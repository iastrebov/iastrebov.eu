---
layout: post
title: "Kubernetes Probes Should Answer One Question Each"
date: 2026-07-20 09:00:00 +0100
categories: software engineering
tags: [kubernetes, reliability, devops]
excerpt_separator: <!--more-->
greeting: hello
description: "Startup, readiness, and liveness probes have distinct jobs. Mixing them can create restart loops, route traffic too early, or amplify dependency failures."
image:
  url: assets/images/blog/2026-07-20-kubernetes-probes-cover.png
  alt: Three diagnostic instruments checking startup readiness and liveness on a service pod
---

A probe is a control signal, not a status page. Kubernetes acts on its result, so the check should correspond precisely to the action that follows. A broad “health” endpoint reused everywhere often turns a small dependency problem into a restart storm.

<!--more-->

The startup probe asks whether the process has finished initializing. While it is failing, liveness checks are held back. This is the right place to accommodate slow class loading, migrations that are safe to run there, or large local caches. Its allowance should cover a realistic cold start, not hide an application that never becomes usable.

Readiness asks whether this instance should receive new traffic. It can fail during startup, shutdown, overload, or loss of a dependency that makes requests impossible to serve. Removing an instance from routing is useful only if remaining instances can absorb the load; otherwise a strict dependency check can cascade through the fleet.

Liveness asks whether restarting the container can repair the condition. A deadlocked event loop may qualify. A down database does not: restarting every client adds load and discards useful diagnostic state while the database remains unavailable. Keep liveness local and conservative.

Probe handlers must be cheap and bounded. They should not allocate heavily, wait behind normal request queues, or perform a fan-out across dependencies. Give them short timeouts and observe their latency and failures separately from business traffic.

Coordinate readiness with termination. Mark the instance unready, allow routing changes to propagate, drain in-flight work, then exit within the platform's grace period. [Graceful shutdown](/blog/graceful-shutdown/) explains that sequence in more detail.

Test failure behavior, not just the happy response. Pause a dependency, saturate the worker pool, and slow startup. The useful question is always: what will the orchestrator do with this bit, and does that action improve the situation?
