---
layout: post
title: "Code Review Can Teach Without Becoming a Lecture"
date: 2026-07-28 09:00:00 +0100
categories: software engineering
tags: [code-review, mentoring, teams]
excerpt_separator: <!--more-->
greeting: hello
description: "Mentoring through code review works when feedback explains impact, separates requirements from preferences, and leaves room for the author to reason."
image:
  url: assets/images/blog/2026-07-28-mentoring-through-code-review-cover.png
  alt: Two connected work surfaces refining one code structure through focused review signals
---

A pull request is a poor place for a surprise seminar. The author needs a clear path to merge, and the reviewer needs to protect the system. Mentoring fits when feedback helps the author understand an engineering consequence without burying the decision in commentary.

<!--more-->

Label the weight of a comment. A correctness or security issue blocks the change. A suggestion offers an improvement. A question asks for context. A minor style preference should be automated or clearly optional. When every comment sounds mandatory, authors spend energy decoding hierarchy instead of considering the design.

Explain impact, not authority. “Move this call outside the transaction because the remote timeout can hold database locks” teaches a reusable principle. “We do not do this here” teaches only obedience. Link to a local example or design record when the convention depends on system-specific context.

Ask questions when the reasoning is unclear, but do not disguise commands as questions. “What happens if two requests reach this branch together?” invites analysis. If concurrency safety is required, say so directly after the risk is established.

Keep scope under control. A review of a small feature should not become a demand to redesign the whole subsystem. Capture worthwhile adjacent work separately unless the current change makes the risk materially worse. This respects delivery while preserving the observation.

Move high-bandwidth disagreements out of the comment thread. Ten rounds of text often mean the participants need a short conversation, a sketch, or a focused design note. Return afterward with the decision and rationale so the review remains understandable.

Reviewers should also notice good decisions—briefly and specifically. Recognition tells the author which judgment to repeat. Over time, review also distributes system knowledge. That is one reason healthy [code ownership](/blog/code-ownership/) never depends on a single gatekeeper.
