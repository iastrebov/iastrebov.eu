---
layout: post
title: "Flaky Tests Are Production Bugs In Your Feedback System"
date: 2026-06-29 20:30:00 +0100
categories: software engineering
tags: [testing, flaky-tests, ci, debugging]
excerpt_separator: <!--more-->
greeting: "rerun is evidence destruction"
description: "Diagnose flaky tests through captured seeds, isolated resources, deterministic time, ordering control, and quarantine with ownership."
image:
  url: assets/images/blog/2026-06-29-flaky-tests-debugging-cover.png
  alt: "A test signal flickering between green and red while hidden shared state is exposed"
---
Rerunning a red build until it turns green trains team to ignore failures. Soon the one real regression looks exactly like background noise.

<!--more-->

## Preserve The Failure

Capture seed, test order, timestamps, environment, thread dump where relevant, and logs for the failing test. Reproduce the same conditions before adding random sleeps.

Common causes are shared mutable fixtures, fixed ports, transaction leakage, wall-clock boundaries, unordered assertions, and asynchronous work surviving test end.

Classify the flake by signal. A consistent assertion mismatch under random order points toward leaked state. A timeout under load suggests a scheduling assumption. A missing callback after the test ends suggests lifecycle leakage. Classification turns “sometimes red” into a smaller search space.

## Stress The Suspect

Run the test repeatedly, in isolation, under random order, and with parallel execution. Each mode narrows the shared assumption.

Quarantine may unblock delivery, but it needs an owner, issue, and expiry. A quarantine folder without deadline is a graveyard where confidence goes to die.

Fix the cause, then keep a regression that would fail under the old condition. Deleting the test proves only that silence is stable.

## Determinism Elsewhere

- [Deterministic Time Tests: Stop Sleeping And Inject A Clock](/blog/deterministic-time-tests/)
- [The Works On My Machine Excuse Ends Here](/blog/works-on-my-machine-excuse-ends-here/)
