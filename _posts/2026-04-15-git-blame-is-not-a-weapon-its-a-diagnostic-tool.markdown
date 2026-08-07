---
layout: post
title: "Git Blame Is Not A Weapon, It's A Diagnostic Tool"
date: 2026-04-15 18:52:00 +0100
categories: software engineering
tags: [engineering-culture, incident-response, git, postmortem]
excerpt_separator: <!--more-->
greeting: "find cause, not victim"
description: "A blameless engineering culture post explaining how git blame, post-mortems, tests, CI, and reviews should diagnose incidents."
image:
  url: assets/images/blog/2026-04-15-git-blame-is-not-a-weapon-its-a-diagnostic-tool-cover.png
  alt: "Two developers pointing fingers while a server rack quietly burns behind them"
---
Git blame has terrible name. People use it like weapon: who wrote this disaster?

Better question: what system allowed disaster to reach production?

<!--more-->

## Blame Finds Person, Not Cause

A junior changed timeout. Service melted. Easy story: junior broke production.

Real story: no test covered timeout. Code review missed risk. Runbook was outdated. Alert fired late. CI allowed risky config. Team knowledge was tribal.

Person touched line. System created conditions.

## Use Blame As Map

<code>git blame</code> tells when and why line changed. Follow commit. Read PR. Understand context. Maybe change was correct for old requirement.

This is diagnostic work, not courtroom.

## Blameless Does Not Mean Consequence-Free

If someone was reckless, address it. But most incidents are normal humans inside weak systems.

Blameless post-mortem asks how to make same mistake harder next time.

## Good Post-Mortem

Includes timeline, impact, detection, contributing factors, what went well, what went poorly, and action items with owners.

Bad post-mortem says "be more careful". This is not action item. This is prayer.

## Engineering Fixes

Add test. Add validation. Add safer default. Add feature flag. Improve alert. Make rollback easier. Document runbook. Remove confusing API.

Culture improves when system improves.

## Final Rule

Use git blame to learn history, not assign shame.

Production reliability comes from stronger systems, not louder finger pointing.

## Related reading

- [The Anatomy Of A Perfect Code Review](/blog/anatomy-of-a-perfect-code-review/)
- [Agile Is Dead, And You Killed It](/blog/agile-is-dead-and-you-killed-it/)
