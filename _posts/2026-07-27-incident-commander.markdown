---
layout: post
title: "An Incident Commander Protects the Debugging Team"
date: 2026-07-27 09:00:00 +0100
categories: software engineering
tags: [incidents, reliability, leadership]
excerpt_separator: <!--more-->
greeting: hello
description: "During a serious incident, one coordinator should manage priorities, communication, and decision state so responders can investigate without chaos."
image:
  url: assets/images/blog/2026-07-27-incident-commander-cover.png
  alt: A central coordination console organizing parallel incident response lanes and status signals
---

A major incident creates two kinds of work. Engineers must understand and mitigate the failure. At the same time, someone must coordinate people, preserve decision state, update stakeholders, and stop ten well-meaning investigations from colliding. The incident commander owns that second system.

<!--more-->

The commander does not need to be the deepest subject expert. In fact, the engineer with the strongest hypothesis is often more valuable investigating it. The commander's job is to maintain a clear objective, assign work, request missing expertise, and decide when the response changes direction.

Keep a live timeline of observations, actions, owners, and results. Distinguish facts from hypotheses. “Errors began after the deploy” is an observation; “the deploy caused the errors” remains a hypothesis until evidence supports it. This discipline prevents the room from repeatedly rediscovering failed paths.

Use one communication channel for response and a separate outward status stream when the incident is large. Responders should not answer the same executive question five times. A liaison can translate the commander's verified summary into customer or leadership updates without exposing raw speculation.

Set a cadence for reassessment. Ask what changed, whether impact is growing, what the safest mitigation is, and which investigations no longer deserve attention. Rollback is a decision with risks, not an automatic ritual—especially when data or dependencies changed.

Hand over explicitly if the incident outlasts one person. Transfer current impact, timeline, active hypotheses, action owners, communication commitments, and the next decision point. An exhausted commander is another operational risk.

Teams learn this role through practice. Run scenarios where information is incomplete and multiple specialists respond at once. Pair that preparation with [actionable alerts](/blog/actionable-alerts/) so the initial page arrives with ownership, impact, and a useful first move.
