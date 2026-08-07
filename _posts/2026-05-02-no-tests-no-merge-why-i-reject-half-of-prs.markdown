---
layout: post
title: "No Tests, No Merge: Why I Reject Half of PRs"
date: 2026-05-02 09:14:00 +0100
categories: software engineering
tags: [tests, tdd, java, code-review]
excerpt_separator: <!--more-->
greeting: "strict gatekeeper mode"
description: "Why pull requests without tests create instant technical debt, hidden fintech risk, and code review waste that senior engineers must reject."
image:
  url: assets/images/blog/2026-05-02-no-tests-no-merge-why-i-reject-half-of-prs-cover.png
  alt: "Red rejected stamp over a dark code review screen with failing test indicators"
---
A pull request without tests is not almost done. It is a story with missing ending, and usually the ending is production incident.

I reject many PRs for this reason. Not because I enjoy being difficult. Because code without executable proof is just opinion with syntax. In fintech this opinion can move money, duplicate money, lose money, or block customer from his own money. Very romantic, yes.

<!--more-->

## Tests Are Part Of The Feature

If your feature changes behavior, the test is not extra ceremony. It is part of the behavior contract.

People say: "I tested manually." Good. You clicked once on your laptop, with warm database, clean cache, and lucky data. Production will not be so polite.

A senior engineer asks boring question: what proves this keeps working after next refactor, next timezone bug, next dependency upgrade?

## Naive Implementation

Look at small payment fee calculator. It looks harmless.

~~~java
final class FeeCalculator {
    BigDecimal fee(BigDecimal amount) {
        if (amount.compareTo(new BigDecimal("1000")) > 0) {
            return amount.multiply(new BigDecimal("0.015"));
        }
        return amount.multiply(new BigDecimal("0.025"));
    }
}
~~~

No rounding mode. No null policy. Boundary at exactly 1000 is implicit. Currency scale is not discussed. Reviewer must reverse-engineer all of it from vibes.

Now make the desired behavior explicit first.

~~~java
class FeeCalculatorTest {
    private final FeeCalculator calculator = new FeeCalculator();

    @Test
    void appliesRetailFeeAtBoundary() {
        assertThat(calculator.fee(new BigDecimal("1000.00")))
            .isEqualByComparingTo(new BigDecimal("25.00"));
    }

    @Test
    void appliesVipFeeAboveBoundaryWithMoneyScale() {
        assertThat(calculator.fee(new BigDecimal("1000.01")))
            .isEqualByComparingTo(new BigDecimal("15.00"));
    }
}
~~~

Now implementation has target.

~~~java
final class FeeCalculator {
    private static final BigDecimal VIP_LIMIT = new BigDecimal("1000.00");
    private static final BigDecimal RETAIL_RATE = new BigDecimal("0.025");
    private static final BigDecimal VIP_RATE = new BigDecimal("0.015");

    BigDecimal fee(BigDecimal amount) {
        Objects.requireNonNull(amount, "amount");
        BigDecimal rate = amount.compareTo(VIP_LIMIT) > 0 ? VIP_RATE : RETAIL_RATE;
        return amount.multiply(rate).setScale(2, RoundingMode.HALF_UP);
    }
}
~~~

This is not longer because we love typing. It is longer because behavior is visible.

## Fintech Does Not Forgive Hand-Waving

In a todo app, missing test is maybe annoying. In payments, it is accounting mismatch, audit question, chargeback, angry partner, and weekend with logs.

Money systems are mostly boring arithmetic plus very expensive edge cases. Tests catch the boring part so humans can focus on the weird part.

## What I Expect In A PR

I want to see tests for happy path, boundaries, failure path, and regression if bug was fixed. I want test names that explain business rule. I want no giant mocked circus that only tests Mockito configuration.

If code changes public behavior and tests do not change, I assume one of two things: behavior did not change, or author did not understand what changed. Both are review blockers.

## But Tests Slow Us Down

No. Missing tests slow us down later, when nobody remembers why code exists. Tests are not speed tax. They are navigation system for future changes.

Bad tests are bad. Slow tests are bad. Brittle tests are bad. This is not argument against tests. This is argument for writing better tests.

## My Rule

No tests, no merge. Exceptions exist for pure docs, obvious style-only cleanup, and throwaway experiments clearly marked as throwaway. Production code is different game.

If you want trust, bring evidence. In engineering, evidence is test suite.

## Related reading

- [Stop Coding, Start Thinking: The True TDD Mindset](/blog/stop-coding-start-thinking-tdd-mindset/)
- [Refactoring Without Tests Is Just Guessing](/blog/refactoring-without-tests-is-just-guessing/)
- [The Anatomy Of A Perfect Code Review](/blog/anatomy-of-a-perfect-code-review/)
