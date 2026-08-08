---
layout: post
title: "SLOs Turn Reliability From An Argument Into A Budget"
date: 2026-07-05 09:10:00 +0100
categories: software engineering
tags: [reliability, slo, error-budget, operations]
excerpt_separator: <!--more-->
greeting: "reliability needs a denominator"
description: "Define service-level indicators, objectives, and error budgets that connect user-visible reliability to practical release decisions."
image:
  url: assets/images/blog/2026-07-05-slo-error-budget-cover.png
  alt: "A precise reliability gauge sharing a finite budget between stability and change"
---
“Make it more reliable” sounds responsible but gives nobody a decision rule. Reliable for whom, measured where, and over what period?

<!--more-->

## Start With A User-Visible Signal

An SLI measures an experience users care about: successful checkout requests, jobs completed before a deadline, or reads served below a latency threshold. CPU utilization is useful telemetry, but users do not buy CPU utilization.

For an availability SLI, count good events over eligible events:

~~~text
successful eligible requests / all eligible requests
~~~

Define eligibility explicitly. Health checks, client cancellations, and invalid requests can distort the number if they drift in and out of the denominator.

## The Objective Creates A Budget

A 99.9% monthly objective permits roughly 43 minutes of unavailability in a 30-day month. That allowance is the error budget. Spend it on deploys, experiments, dependency failures, and mistakes—but spend it consciously.

When burn is fast, slow releases and fund reliability work. When the budget is healthy, do not demand imaginary perfection. A target of 100% usually produces either paralysis or dishonest measurement.

SLA is the external promise and may carry contractual consequences. SLO is the internal operating target. Keep the SLO stricter enough to reveal trouble before the contract is breached.

## The Useful Conversation

Review budget consumption with product and engineering. “We have consumed 70% in six days” is actionable. “Operations feels nervous” is not.

## Keep Reading

- [How To Survive Your First On-Call Shift](/blog/how-to-survive-your-first-on-call-shift/)
- [Timeout Budgets: Your 200 ms Service Cannot Make Three 200 ms Calls](/blog/timeout-budget-distributed-systems/)
