---
layout: post
title: "Don't Be A Yes Man: How To Push Back On Product Managers"
date: 2025-12-30 10:39:00 +0000
categories: software engineering
tags: [career, product-management, communication, senior-engineer]
excerpt_separator: <!--more-->
greeting: "protect system with options"
description: "Career advice for engineers on saying no to unsafe deadlines, explaining trade-offs, and offering product-safe alternatives."
image:
  url: assets/images/blog/2025-12-30-dont-be-a-yes-man-how-to-push-back-on-product-managers-cover.png
  alt: "Energy shield blocking sticky notes and urgent stamps from shadowy figures"
---
Your job is not to make product manager happy by saying yes. Your job is to help company ship useful software without destroying system.

If requirement is unsafe, deadline fake, or scope impossible, silence is not professionalism. It is negligence with polite face.

<!--more-->

## Pushback Is Not Conflict

Good product managers want truth early. Bad product managers want yes until incident.

Engineer must turn risk into clear trade-off. Not drama. Not ego. Just facts.

## Script: Impossible Deadline

> I do not think full scope is safe by Friday. The risky part is payment reversal flow and we need integration tests. We can ship read-only audit view by Friday, or ship full reversal next Wednesday with tests and rollback plan. Which outcome is more important?

This is no plus options.

## Script: Missing Requirement

> I cannot estimate this until we define what happens when provider accepts request but our callback times out. That failure mode changes design. Let us decide it now instead of discovering in production.

This is how senior sounds.

## Script: Quality Shortcut

> Skipping tests saves maybe one day now and creates risk in money movement. I recommend cutting export polish instead. We keep core flow tested and reduce UI scope.

Protect core, trade optional.

## Do Not Hide Behind Tech Words

Product does not need lecture about CAP theorem every time. Explain impact.

Bad: "We need eventual consistency due to distributed transaction semantics."

Better: "User may see pending state for up to one minute, but we avoid double charge and can recover safely."

## Document Decisions

If team accepts risk, write it. Not as threat. As memory.

> Decision: ship without bulk retry UI. Manual support process remains for first release. Revisit after volume exceeds 100/day.

Written trade-off prevents future amnesia.

## Final Rule

A yes man is not helpful. He is delayed failure.

Be direct, calm, and practical. Say no to unsafe path, then show safer path forward.

## Related reading

- [Seniority Is Not About Years Of Experience](/blog/seniority-is-not-about-years-of-experience/)
- [Burnout Is For Those Who Cannot Say No](/blog/burnout-is-for-those-who-cant-say-no/)
- [Agile Is Dead, And You Killed It](/blog/agile-is-dead-and-you-killed-it/)
