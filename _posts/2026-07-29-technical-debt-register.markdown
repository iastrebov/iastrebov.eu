---
layout: post
title: "A Technical Debt Register Must Drive Decisions"
date: 2026-07-29 09:00:00 +0100
categories: software engineering
tags: [technical-debt, planning, maintenance]
excerpt_separator: <!--more-->
greeting: hello
description: "A useful technical debt register records business impact, trigger conditions, ownership, and evidence so maintenance work can compete with feature priorities."
image:
  url: assets/images/blog/2026-07-29-technical-debt-register-cover.png
  alt: A maintenance ledger linking system cracks to measurable cost and prioritized repair work
---

A list containing “refactor payments,” “fix legacy service,” and “improve tests” is not a technical debt strategy. It is a warehouse for discomfort. Items survive for years because nobody can compare them with product work or decide when they matter.

<!--more-->

Record the consequence in observable terms. Does the problem add two days to every integration? Cause a recurring incident? Prevent a framework upgrade? Require manual reconciliation each week? Cost and risk make the item discussable; aesthetic dissatisfaction alone rarely does.

Add evidence and scope. Link incidents, slow pipeline measurements, vulnerable dependencies, or examples of repeated change difficulty. State which component is affected and which is not. “Untangle the backend” cannot be estimated or completed; “separate invoice calculation from the HTTP controller so three consumers can share it” can.

Give each item an owner and a trigger. Some debt deserves immediate repair because it creates active security or reliability risk. Some should be addressed when nearby feature work opens the component. Some is cheaper to tolerate until traffic or team size crosses a threshold. Writing the trigger prevents both endless postponement and reflexive cleanup.

Review the register on a steady cadence, archive items that no longer matter, and split discoveries from commitments. A thousand-item backlog hides the few debts that actually constrain the roadmap. The register should support prioritization, not preserve every historical complaint.

Reserve capacity for maintenance, but do not assume a fixed percentage solves prioritization. A severe migration blocker may need concentrated work; ten low-impact cleanup items may need none this quarter. Use the same outcome language applied to features.

When a debt item leads to a structural choice, capture the reasoning in an [architecture decision record](/blog/architecture-decision-records/). The register explains why action matters now; the record explains why the chosen solution should endure.
