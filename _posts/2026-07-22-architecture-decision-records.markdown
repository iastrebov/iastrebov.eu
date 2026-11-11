---
layout: post
title: "Architecture Decision Records Preserve the Why"
date: 2026-07-22 09:00:00 +0100
categories: software engineering
tags: [architecture, documentation, decisions]
excerpt_separator: <!--more-->
greeting: hello
description: "A useful architecture decision record captures context, constraints, alternatives, and consequences close to the code without becoming ceremonial paperwork."
image:
  url: assets/images/blog/2026-07-22-architecture-decision-records-cover.png
  alt: A durable decision ledger connecting a branching architecture map to one chosen route
---

Code preserves what the system does. It rarely preserves why one design survived and another was rejected. Six months later, a reasonable constraint can look like an arbitrary mistake. The team may repeat the investigation or remove a guardrail without understanding its purpose.

<!--more-->

An architecture decision record, or ADR, is a short document for one consequential choice. Keep it beside the repository when possible so reviews, history, and ownership follow the code. A practical record contains the decision's status, context, options considered, chosen approach, and consequences.

Context is the most valuable section. Capture the forces that made the choice non-obvious. These include scale, regulatory limits, team skills, deadlines, existing contracts, and failure tolerance. Avoid rewriting the final design as if it were inevitable.

Consequences should include costs. “We chose asynchronous events” is incomplete without noting delayed consistency, duplicate handling, observability needs, and operational ownership. A decision with no downside usually has not been examined closely enough.

ADRs are not immutable law. When circumstances change, supersede an old record with a new one and link them. Retaining the old context explains why the earlier choice was sound at the time. Editing history into a tidy fiction removes that value.

Write a record for decisions that constrain future work, introduce significant dependencies, or establish cross-team conventions. Include decisions that are expensive to reverse. Do not require one for every class name or routine refactor. The format should reduce repeated debate, not create an approval bureaucracy.

The best moment to draft an ADR is during design, while alternatives are still real. Review it with the people who will operate and maintain the result, then keep its claims testable. For module boundaries, for example, the record can point to the automated rules described in [a modular monolith needs enforced boundaries](/blog/modular-monolith-boundaries/).
