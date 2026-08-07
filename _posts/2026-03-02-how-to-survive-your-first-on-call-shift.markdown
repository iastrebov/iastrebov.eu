---
layout: post
title: "How To Survive Your First On-Call Shift"
date: 2026-03-02 03:00:00 +0000
categories: software engineering
tags: [on-call, career, incident-response, observability]
excerpt_separator: <!--more-->
greeting: "do not panic, collect signal"
description: "A practical survival guide for first on-call shifts: dashboards, rollback, communication, runbooks, and staying calm at 3 AM."
image:
  url: assets/images/blog/2026-03-02-how-to-survive-your-first-on-call-shift-cover.png
  alt: "PagerDuty alert at 3 AM lighting a stressed engineer in a dark bedroom"
---
First on-call shift teaches one thing fast: production is real and does not care that you are junior.

Do not panic. Panic wastes glucose. Collect signal.

<!--more-->

## First Minute

Acknowledge alert. Breathe. Read alert title, service, severity, dashboard link, and runbook. Do not start changing production because phone made scary sound.

Your first job is to understand blast radius.

## Check Dashboards First

Look at golden signals: traffic, errors, latency, saturation. Compare now with previous hour and previous week. Check recent deploys. Check dependency status.

Most incidents are not solved by staring at one log line.

## Communicate Early

Say what you know and what you do not know.

> Investigating elevated payment API 5xx since 02:57 UTC. Current impact appears limited to card authorization. Checking recent deploy and gateway dependency now. Next update in 10 minutes.

This calms room and buys focused time.

## Know Rollback Before You Need It

Before your first shift, practice rollback in non-production. Know command, dashboard, approval path, and how to verify result.

If rollback is scary, team has deployment problem.

## Do Not Debug Alone Forever

Have escalation rule. If severity is high or you are stuck beyond agreed time, page secondary. This is not weakness. This is incident management.

Production is team sport.

## After Incident

Write notes while fresh: timeline, symptoms, actions, commands, dashboards, decisions. Post-mortem later will need facts, not memory fog.

Ask what would make next alert easier: better runbook, clearer metric, safer deploy, missing test, dependency timeout.

## On-Call Makes You Better

It connects code to consequence. Suddenly bad logs matter. Slow queries matter. Missing health check matters. Unclear ownership matters.

Good on-call culture turns pain into system improvement.

## Final Rule

At 3 AM, be boring. Read alert. Check dashboards. Communicate. Roll back when needed. Escalate early.

Hero debugging is for movies. Production wants calm process.

## Related reading

- [10 Years In Big Tech: The Ugly Truth About Fintech](/blog/10-years-in-big-tech-ugly-truth-about-fintech/)
- [Burnout Is For Those Who Cannot Say No](/blog/burnout-is-for-those-who-cant-say-no/)
- [Git Blame Is Not A Weapon, It's A Diagnostic Tool](/blog/git-blame-is-not-a-weapon-its-a-diagnostic-tool/)
