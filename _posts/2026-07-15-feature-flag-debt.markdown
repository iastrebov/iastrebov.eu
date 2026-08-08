---
layout: post
title: "Feature Flags Need an Expiration Date"
date: 2026-07-15 09:00:00 +0100
categories: software engineering
tags: [architecture, delivery, feature-flags]
excerpt_separator: <!--more-->
greeting: hello
description: "Feature flags make releases safer, but stale flags create hidden branches, confusing tests, and operational debt. Treat every flag as temporary code."
image:
  url: assets/images/blog/2026-07-15-feature-flag-debt-cover.png
  alt: A switchboard where temporary routes have accumulated into tangled permanent wiring
---

A feature flag is a controlled branch in production. That is useful during a rollout, but it is still a branch: both paths can affect behavior, tests, monitoring, and incident response. A codebase with fifty forgotten flags has quietly acquired dozens of runtime configurations that nobody intended to support forever.

<!--more-->

The expensive part is not evaluating a boolean. It is uncertainty. Can the old path still run? Which customers see the new path? Must a database column remain compatible with both? When an alert fires, responders first have to reconstruct the flag state.

Give each flag an owner, a purpose, and an expiration condition when it is created. The condition should be concrete: “remove after 100% rollout remains healthy for seven days,” not “clean up later.” A small registry can capture the flag key, creation date, owner, expected removal date, and whether the flag is operational or release-related.

Different flags deserve different lifetimes. A release flag should usually disappear soon after rollout. An operational kill switch may remain, but it needs a tested off-path and clear runbook. A long-lived entitlement is product configuration, not a temporary release flag; model it accordingly.

Removal is part of the rollout. Delete the losing branch, remove obsolete metrics, collapse tests to the surviving behavior, and retire any compatibility schema that existed only for the transition. Automate reminders for overdue flags, but make a team accountable for acting on them.

Flags reduce release risk by moving the decision from deployment time to runtime. That trade is worthwhile only when the temporary complexity is actually temporary. For the rollout mechanics around that decision, compare [blue-green and canary releases](/blog/blue-green-vs-canary/).
