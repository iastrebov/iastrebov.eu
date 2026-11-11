---
layout: post
title: "Fast CI Is a Feedback Design Problem"
date: 2026-07-18 09:00:00 +0100
categories: software engineering
tags: [ci, testing, delivery]
excerpt_separator: <!--more-->
greeting: hello
description: "A fast CI pipeline reports useful failures early, avoids duplicated work, and keeps slow confidence checks without forcing every developer to wait for them."
image:
  url: assets/images/blog/2026-07-18-fast-ci-pipelines-cover.png
  alt: A software delivery pipeline split into fast parallel lanes with an early failure gate
---

The important CI metric is not total machine time. It is time to trustworthy feedback. A ten-minute pipeline that reports a compile error after thirty seconds is more useful than an eight-minute pipeline that reveals every result at the end.

<!--more-->

Start by measuring stage duration, queue time, and failure frequency. Sort failures by the developer time they waste. Compilation, formatting, static analysis, and focused unit tests usually belong near the front because they are cheap and catch common defects. Broader integration and system tests can run in parallel once the build artifact exists.

Build once. Recompiling independently in every job wastes time and creates the possibility that jobs test different artifacts. Produce an immutable artifact, record its identity, and promote that same object through later checks.

Caching helps only when correctness is explicit. Key dependency caches by lockfile and toolchain inputs. Do not cache ambiguous build output merely because it is expensive. A stale cache that produces an impossible failure destroys more confidence than it saves minutes.

Use test selection carefully. Running tests affected by a change can speed pull-request feedback, but the dependency map will sometimes be incomplete. Run the full suite on a schedule or before final promotion. Track failures it finds that selective runs missed.

Flaky tests are latency multipliers. A retry can distinguish intermittent behavior, but it should also record and quarantine the test for repair. Otherwise the pipeline becomes green by attrition. The deeper remediation is covered in [flaky tests are production bugs in the feedback system](/blog/flaky-tests-debugging/).

Set a feedback budget for each layer and treat regressions like performance regressions in a service. CI is part of the development system. When it becomes slow or untrusted, teams compensate with larger changes and fewer runs. That is exactly when fast feedback matters most.
