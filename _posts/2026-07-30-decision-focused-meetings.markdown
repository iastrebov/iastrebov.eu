---
layout: post
title: "Design Meetings Should Produce Decisions"
date: 2026-07-30 09:00:00 +0100
categories: software engineering
tags: [meetings, decisions, teams]
excerpt_separator: <!--more-->
greeting: hello
description: "A productive design meeting starts with a written decision, brings the necessary roles, and ends with owners, unresolved risks, and recorded rationale."
image:
  url: assets/images/blog/2026-07-30-decision-focused-meetings-cover.png
  alt: A focused decision table converging several option paths into one recorded outcome
---

“Discuss the new service” is an invitation to exchange context without knowing when the meeting is finished. A useful design meeting names the decision it must produce: select an event contract, approve a migration sequence, or choose between two ownership boundaries.

<!--more-->

Send a short written proposal before the meeting. It should contain the problem, constraints, recommendation, alternatives, and open questions. Participants can spend synchronous time on disagreement and tradeoffs instead of watching the author reveal basic context slide by slide.

Invite roles, not spectators. The decision may need the owning engineer, an operator, a security or data representative, and the person accountable for the outcome. A larger audience does not create broader alignment if most people lack either context or decision authority.

At the start, state who decides and what evidence could change the recommendation. Consensus is valuable but not always available. Ambiguous authority turns the final ten minutes into a vague promise to “circle back.”

Keep a visible list of questions and decisions during the conversation. Separate objections that block the proposal from improvements that can follow later. If a critical unknown requires investigation, assign a small experiment with an owner and deadline rather than continuing to argue from assumptions.

End by reading back the result: decision, rationale, dissent or residual risk, action owners, and review date if the choice is reversible or conditional. Publish that summary where future maintainers will find it. Significant decisions can graduate into an [architecture decision record](/blog/architecture-decision-records/).

Cancel the meeting when comments resolve the proposal asynchronously. Schedule one when written discussion loops, conflict depends on tone, or several disciplines must negotiate at once. The goal is neither fewer meetings nor more collaboration. It is to use synchronous attention for decisions that genuinely benefit from it.
