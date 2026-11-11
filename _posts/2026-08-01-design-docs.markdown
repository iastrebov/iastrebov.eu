---
layout: post
title: "Write Design Documents for the Hard Questions"
date: 2026-08-01 09:00:00 +0100
categories: software engineering
tags: [design, documentation, architecture]
excerpt_separator: <!--more-->
greeting: hello
description: "A design document should make constraints, failure modes, alternatives, and rollout choices reviewable before implementation makes them expensive to change."
image:
  url: assets/images/blog/2026-08-01-design-docs-cover.png
  alt: An engineering blueprint exposing constraints failure paths and a staged rollout before construction
---

A design document is valuable when the hard part of a change is deciding, not typing. It gives reviewers a cheaper object to challenge before interfaces solidify, data moves, or several teams build against incompatible assumptions.

<!--more-->

Open with the problem and measurable goal. “Introduce a queue” is a proposed mechanism. “Absorb traffic spikes without dropping accepted jobs, while completing 99% within five minutes” describes the outcome and lets reviewers consider other mechanisms.

State constraints and non-goals. Existing contracts, data residency, delivery deadlines, team ownership, and acceptable consistency shape the design. Non-goals prevent a bounded project from silently becoming a platform rewrite.

Spend detail on the risky edges: data model, concurrency, failure behavior, authorization, capacity, migration, observability, and rollback. A happy-path component diagram is easy to produce and often says least about whether the system will survive production.

Present serious alternatives. Explain why each was rejected under the current constraints, including the cost of the chosen approach. Reviewers can then challenge the reasoning rather than guessing which options were ignored.

Include a staged delivery plan. Identify compatibility periods, feature flags, schema expansion, backfills, validation, and the signal required to proceed. Name the owner of operational readiness as well as implementation.

Keep the document proportional. A one-page change may need a one-page design. A cross-region data migration deserves more. Use diagrams when they clarify flow or ownership. Do not decorate straightforward prose.

After approval, record durable choices as [architecture decision records](/blog/architecture-decision-records/) and update the design when implementation disproves an assumption. The document is a tool for shared reasoning, not evidence that the original author predicted everything correctly.
