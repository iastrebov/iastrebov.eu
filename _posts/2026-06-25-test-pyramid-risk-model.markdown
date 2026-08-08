---
layout: post
title: "The Test Pyramid Is A Cost Model, Not A Quota"
date: 2026-06-25 08:05:00 +0100
categories: software engineering
tags: [testing, architecture, java, quality]
excerpt_separator: <!--more-->
greeting: "test where the failure lives"
description: "Use the test pyramid as a feedback-cost model and place tests at domain, adapter, contract, and end-to-end boundaries according to risk."
image:
  url: assets/images/blog/2026-06-25-test-pyramid-risk-model-cover.png
  alt: "A test pyramid balanced by feedback speed, realism, and failure cost"
---
“Seventy percent unit tests” is not a quality strategy. Percent of what: methods, behaviors, lines, or effort?

The test pyramid is useful because fast isolated checks are cheap and full-system checks are expensive. It does not assign universal quotas.

<!--more-->

## Match Boundary To Failure

A fee calculation needs a pure domain test. A SQL query needs a real database. A JSON compatibility promise needs a serialization or API test. One end-to-end flow proves the wiring.

Testing SQL through a mocked repository is cheap and irrelevant. Starting the whole application to test addition is realistic and wasteful.

## Keep A Small Expensive Layer

End-to-end tests are slower, harder to diagnose, and sensitive to environment. Keep enough to cover critical journeys and deployment wiring. Do not ask them to enumerate every business boundary.

Track suite duration and failure diagnosis time. A test that fails randomly creates negative confidence even if it lives in correct geometric layer.

Duplication across layers is not automatically waste. A domain rule may have exhaustive unit coverage and one broader test proving the real adapter invokes it correctly. The mistake is repeating the same edge-case matrix through every boundary. Let each layer answer a different failure question.

Start from risks, choose cheapest boundary that can observe each one, then keep a few broad checks for integration gaps. That is pyramid thinking without spreadsheet religion.

## Related Tradeoffs

- [Mockito Is Not A Testing Strategy](/blog/why-i-ban-mockito-in-my-teams/)
- [Your 100% Test Coverage Is A Lie](/blog/your-100-percent-test-coverage-is-a-lie/)
