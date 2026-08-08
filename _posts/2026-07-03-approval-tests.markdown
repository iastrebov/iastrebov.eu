---
layout: post
title: "Approval Tests: Snapshot The Contract, Not The Noise"
date: 2026-07-03 18:50:00 +0100
categories: software engineering
tags: [testing, approval-tests, legacy-code, contracts]
excerpt_separator: <!--more-->
greeting: "a diff needs a human decision"
description: "Use approval tests for complex stable output while normalizing nondeterminism, reviewing diffs, and avoiding snapshots nobody reads."
image:
  url: assets/images/blog/2026-07-03-approval-tests-cover.png
  alt: "A human reviewing a focused output diff while timestamps and random IDs are filtered away"
---
Approval tests capture output and ask a reviewer to approve a diff. They are powerful for reports, serializers, compilers, and legacy behavior. They are terrible when a team updates snapshots without reading them.

<!--more-->

## Remove Accidental Noise

Normalize generated IDs, timestamps, unstable map order, and environment paths only when those values are not part of contract. Otherwise every run changes and real differences disappear in confetti.

Keep approved files small enough to inspect. Split a giant report by meaningful section rather than blessing 20,000 lines.

## Pair With Focused Assertions

A snapshot shows broad change. A focused assertion explains a critical invariant. Use both when one amount or status must never drift unnoticed.

Reviewers must understand why output changed and regenerate through a documented command. “Update all snapshots” is not validation; it is deleting alarms with extra steps.

Store approved output in a reviewable text format when possible. Binary snapshots hide the meaningful change behind tooling. If the real artifact is binary, derive a stable semantic representation for review and keep one focused integration check for the encoder itself.

That keeps the diff useful during ordinary code review.

## Good Companion Tests

- [Refactoring Without Tests Is Just Guessing](/blog/refactoring-without-tests-is-just-guessing/)
- [OpenAPI Contract Testing: Documentation Must Be Executable](/blog/openapi-contract-testing/)
