---
layout: post
title: "An Alert Without An Action Is Just Expensive Noise"
date: 2026-07-06 10:20:00 +0100
categories: software engineering
tags: [observability, alerting, on-call, reliability]
excerpt_separator: <!--more-->
greeting: "page on symptoms, investigate causes"
description: "Reduce alert fatigue by paging on user-visible symptoms, attaching ownership and runbooks, and measuring whether alerts earn attention."
image:
  url: assets/images/blog/2026-07-06-actionable-alerts-cover.png
  alt: "One clear red signal separated from a wall of muted notification noise"
---
A pager is an interruption with a high human cost. Every rule should justify why somebody must stop sleeping or stop focused work now.

<!--more-->

## Page On Consequences

Page when users are failing, an SLO is burning dangerously fast, or data is at immediate risk. A single process restart, a brief CPU spike, or one failed background job usually belongs in a dashboard or ticket.

Cause-based alerts are brittle. “Database CPU above 80%” may be harmless; “checkout success below 98% for ten minutes” describes an actual consequence. Use infrastructure signals to diagnose the page, not automatically to create five more pages.

## Give The Responder A First Move

Every alert needs an owner, severity, affected service, useful dashboard, and short runbook. The description should say what condition fired, not merely repeat an opaque rule name.

Test the route. A perfect threshold sent to an abandoned channel is theatre.

## Review The Pager As A Product

Track pages per shift, acknowledgement time, false positives, repeated causes, and alerts closed without action. After an incident, ask whether the alert arrived before user reports and whether it pointed toward the fault.

Delete or demote rules that never change a decision. Tune noisy windows. Combine correlated symptoms. Automate safe remediation only after the failure mode is understood.

Alert fatigue is not a discipline problem. It is a signal-quality defect in the operational interface.

## Related Practice

- [SLOs Turn Reliability From An Argument Into A Budget](/blog/slo-error-budget/)
- [Log Like Your Job Depends On It Because It Does](/blog/log-like-your-job-depends-on-it-because-it-does/)
