---
layout: post
title: "Java Flight Recorder: Profile Production Without Guessing"
date: 2026-05-14 14:45:00 +0100
categories: software engineering
tags: [java, jfr, observability, performance]
excerpt_separator: <!--more-->
greeting: "record first, explain second"
description: "Use Java Flight Recorder to investigate CPU, allocation, locks, I/O, and latency with bounded recordings and a clear production question."
image:
  url: assets/images/blog/2026-05-14-java-flight-recorder-production-cover.png
  alt: "A black-box flight recorder capturing JVM events from a glowing server engine"
---
The profiler you never attach during the incident cannot help you. Java Flight Recorder exists to make useful JVM evidence practical in real environments, not only on a developer laptop.

The important step is choosing a question before opening the recording.

<!--more-->

## Start A Bounded Recording

If `jcmd` can reach the process, a short recording can be started without restarting the service:

~~~bash
jcmd <pid> JFR.start \
  name=latency-investigation \
  settings=profile \
  duration=5m \
  filename=/safe/path/latency.jfr
~~~

The exact destination and settings must fit your environment. Do not fill a small container filesystem during an incident. Treat recordings as operational data; they may contain class names, paths, and application context that need controlled handling.

## Ask One Question At A Time

“Why is service slow?” is too wide. Better questions:

- Which methods consume CPU during the spike?
- Which allocation sites create most bytes?
- Which monitors hold threads longest?
- Do socket reads align with dependency latency?
- Did garbage collection overlap the request tail?

This focus prevents you from browsing colorful charts until one looks guilty.

## Samples Are Not Exact Accounting

Execution samples show where CPU time is observed. They are statistical. A method with no sample is not proven free; a hot sample needs context about call count and workload.

Allocation events also need scale. One huge allocation and millions of small allocations demand different fixes.

## Correlate With Service Telemetry

Mark the incident interval in metrics and traces. Compare deployment time, traffic, error rate, pool saturation, and JFR timestamps. A recording is one layer of evidence.

If a trace says 700 ms was spent waiting on PostgreSQL and JFR shows little CPU, rewriting a Java loop is ceremony. If JFR shows monitor contention around a cache while database is calm, SQL tuning is same kind of ceremony.

## Make Capture A Runbook Step

Document who may start a recording, safe duration, storage path, transfer process, and cleanup. Practice outside incident. A command assembled from memory at 03:00 has creative potential you do not need.

Flight Recorder does not replace reasoning. It replaces a worse input to reasoning: guesses spoken with confidence.


- [String Theory: Optimizing Memory In High-Load Systems](/blog/string-theory-optimizing-memory-high-load-systems/)
- [How To Survive Your First On-Call Shift](/blog/how-to-survive-your-first-on-call-shift/)
