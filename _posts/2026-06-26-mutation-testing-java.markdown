---
layout: post
title: "Mutation Testing: Make Sure Your Assertions Can Kill A Bug"
date: 2026-06-26 18:35:00 +0100
categories: software engineering
tags: [testing, mutation-testing, java, quality]
excerpt_separator: <!--more-->
greeting: "executed code is not verified code"
description: "Use mutation testing on critical Java logic to expose weak assertions, missing boundaries, equivalent mutations, and hollow coverage."
image:
  url: assets/images/blog/2026-06-26-mutation-testing-java-cover.png
  alt: "Small controlled code mutations challenged by a test suite, with survivors highlighted"
---
A test can execute an `if` statement and never prove its condition matters. Coverage paints the line green anyway.

Mutation testing changes code deliberately and asks whether the suite notices.

<!--more-->

## A Survivor Is A Question

Change `>` to `>=`, remove a method call, or replace a return value. If tests stay green, either an assertion is weak, a boundary is missing, or the mutation is behaviorally equivalent.

~~~java
boolean allowed(Money used, Money limit) {
    return used.compareTo(limit) <= 0;
}
~~~

A mutant changing `<=` to `<` should die on the exact-limit case.

## Do Not Mutate The Universe First

Run mutation analysis on dense business logic and recently changed modules. Generated DTOs and trivial accessors create noise and cost.

Review survivors; do not chase a 100% mutation score blindly. Equivalent mutants may not be killable, and low-value code still remains low value.

Mutation runs also need a stable baseline. If ordinary tests are flaky, a surviving mutant is ambiguous and the analysis multiplies the noise. Repair nondeterminism first, then compare mutation results over changed code rather than treating the score as an organization-wide ranking.

The useful metric is not trophy number. It is the list of business decisions your assertions failed to defend.

## Where Mutation Fits

- [Your 100% Test Coverage Is A Lie](/blog/your-100-percent-test-coverage-is-a-lie/)
- [No Tests, No Merge: The Evidence A Pull Request Owes You](/blog/no-tests-no-merge-why-i-reject-half-of-prs/)
