---
layout: post
title: "Use Estimation Ranges to Expose Uncertainty"
date: 2026-07-26 09:00:00 +0100
categories: software engineering
tags: [planning, estimation, teams]
excerpt_separator: <!--more-->
greeting: hello
description: "A range communicates what an engineering estimate actually contains: known work, unresolved assumptions, and a confidence level that should change with evidence."
image:
  url: assets/images/blog/2026-07-26-estimation-ranges-cover.png
  alt: A planning instrument displaying a narrowing interval as uncertain work becomes understood
---

“This will take eight days” sounds precise, even when the work includes an undocumented integration and an unfamiliar migration. The number quickly becomes a promise while the uncertainty disappears from the conversation. A range makes that uncertainty visible.

<!--more-->

An estimate such as “one to three weeks” is not complete by itself. State what drives the width: an external API may support the required filter, the existing data may be clean enough to migrate directly, or the team may need a compatibility layer. These are assumptions that can be tested.

Attach a confidence statement and a date for revision. Early discovery might justify a broad range at moderate confidence. After a spike, contract test, or schema sample, the range should narrow—or move. Updating an estimate after learning is evidence of a functioning process, not failure.

Separate effort from elapsed time. Five engineer-days do not guarantee delivery within one calendar week when reviews, dependency teams, release windows, and production observation are part of the path. Show important external waits explicitly.

Use decomposition to find uncertainty, not to manufacture precision. Break the work into decisions, integrations, migrations, implementation, and rollout. The unfamiliar item deserves investigation; assigning every task a decimal does not make it known.

When stakeholders need a commitment, discuss which variable can move: scope, date, staffing, or risk. A fixed deadline may be possible with a smaller first slice and a staged rollout. Hiding the tradeoff inside a single optimistic number merely delays the conversation.

After delivery, compare the result with the assumptions, not only with the midpoint. The useful lesson is often “vendor approval added nine days” or “the migration path was simpler than expected.” Feed that evidence into the next plan and capture consequential choices in a concise [design document](/blog/design-docs/).
