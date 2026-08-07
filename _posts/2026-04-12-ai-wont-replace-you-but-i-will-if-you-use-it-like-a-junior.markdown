---
layout: post
title: "AI Won't Replace You, But I Will If You Use It Like A Junior"
date: 2026-04-12 12:31:00 +0100
categories: software engineering
tags: [ai, career, testing, engineering]
excerpt_separator: <!--more-->
greeting: "use tools with tests"
description: "A strict take on AI coding tools: seniors use AI to accelerate known work, juniors use it blindly and ship bugs faster."
image:
  url: assets/images/blog/2026-04-12-ai-wont-replace-you-but-i-will-if-you-use-it-like-a-junior-cover.png
  alt: "Cyberpunk robot guiding a developer using a glowing wrench beside code tests"
---
AI will not replace good engineers tomorrow. But engineers who use AI to produce code they do not understand are volunteering for replacement.

Tool is not problem. Blind trust is problem.

<!--more-->

## Junior Use Of AI

Junior prompt: "Build payment retry service." AI returns plausible code. Junior pastes. Tests? Maybe generated. Understanding? Thin. Edge cases? Unknown.

Now team owns confident bug machine.

AI is excellent at sounding right. Production only cares about being right.

## Senior Use Of AI

Senior uses AI like fast assistant: generate boilerplate, suggest test cases, convert DTO mapping, draft regex, explain unfamiliar library, create first pass of migration script.

Then senior reads code, edits design, adds tests, and checks behavior. AI accelerates known direction. It does not choose responsibility.

## AI Needs TDD Safety Net

When AI writes code, test first becomes more important, not less.

~~~java
@Test
void retriesOnlyTransientFailures() {
    RetryPolicy policy = new RetryPolicy(3);

    assertThat(policy.shouldRetry(new TimeoutException(), 1)).isTrue();
    assertThat(policy.shouldRetry(new ValidationException("bad iban"), 1)).isFalse();
}
~~~

Now ask AI to implement. If it retries validation failures, test catches nonsense.

Without tests, AI just helps you ship unknown faster.

## Prompting Is Not Engineering

Good prompt can improve output. It cannot replace domain understanding.

You still need know idempotency, race conditions, transaction boundaries, memory usage, security, deployment, and observability.

If model suggests storing API key in source code, senior laughs and fixes. Junior maybe commits.

## Review AI Code Harder

AI code often has shape of correctness: nice names, smooth comments, familiar patterns. This makes it dangerous. Bugs hide behind fluent style.

Check assumptions. Delete unnecessary abstraction. Verify library APIs. Run tests. Add negative cases.

## Where AI Is Wonderful

I like AI for scaffolding repetitive tests, producing alternative names, summarizing docs, creating first version of README, generating data builders, or translating ugly SQL into readable explanation.

This saves energy for decisions only engineer can own.

## Career Risk

If your value is typing boilerplate, AI is threat.

If your value is understanding systems, defining constraints, preventing incidents, and mentoring people, AI is tool.

## Final Rule

Use AI as amplifier, not autopilot. Amplifier makes strong signal stronger and bad signal louder.

Bring tests. Bring judgment. Otherwise you are just faster junior with expensive autocomplete.

## Related reading

- [No Tests, No Merge: Why I Reject Half of PRs](/blog/no-tests-no-merge-why-i-reject-half-of-prs/)
- [Seniority Is Not About Years Of Experience](/blog/seniority-is-not-about-years-of-experience/)
