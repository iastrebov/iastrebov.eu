---
layout: post
title: "Property-Based Testing: Stop Hand-Picking Polite Inputs"
date: 2026-06-27 07:15:00 +0100
categories: software engineering
tags: [testing, property-based-testing, algorithms, java]
excerpt_separator: <!--more-->
greeting: "invariants survive more than examples"
description: "Use property-based testing to generate edge cases, state invariants, shrink failures, and test algorithms beyond a few friendly examples."
image:
  url: assets/images/blog/2026-06-27-property-based-testing-cover.png
  alt: "A generator sending many hostile inputs through one invariant gate and shrinking a failure"
---
Three example tests often describe three memories the developer happened to have. A property describes what must remain true across a space of inputs.

<!--more-->

## State The Invariant

For sorting: output is ordered and contains the same multiset. For serialization: decoding an encoded valid value returns the original. For money allocation: parts plus remainder equal total.

~~~java
@Property
void allocationPreservesTotal(@ForAll @Positive int cents,
                              @ForAll @IntRange(min = 1, max = 100) int parts) {
    Allocation a = allocate(cents, parts);
    assertThat(a.items().stream().mapToInt(Integer::intValue).sum())
        .isEqualTo(cents);
}
~~~

## Generators Are Domain Models

Generate valid and invalid values deliberately. Random strings rarely exercise currency scale, Unicode normalization, or date transitions usefully.

Good tools shrink a failing case to the smallest counterexample. Keep the seed in test output so the failure reproduces.

Limit generators according to the contract, not according to what is convenient for the implementation. If a value may contain any valid Unicode, an ASCII-only generator protects a false assumption. Conversely, generating malformed objects through constructors that promise validity tests an impossible state and produces noise.

Property tests complement precise examples. When one counterexample reveals a regression, add a named example if it teaches future readers something important.

## Nearby Techniques

- [Competitive Programming: Superpower Or Waste Of Time?](/blog/competitive-programming-superpower-or-waste-of-time/)
- [BigDecimal For Money: The Java Rules That Prevent Quiet Corruption](/blog/bigdecimal-money-java/)
