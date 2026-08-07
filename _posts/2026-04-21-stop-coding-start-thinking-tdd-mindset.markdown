---
layout: post
title: "Stop Coding, Start Thinking: The True TDD Mindset"
date: 2026-04-21 20:36:00 +0100
categories: software engineering
tags: [tdd, java, junit, testing]
excerpt_separator: <!--more-->
greeting: "red green refactor"
description: "A practical Java and JUnit 5 guide to the real TDD mindset: design behavior first, then code the simplest thing that passes."
image:
  url: assets/images/blog/2026-04-21-stop-coding-start-thinking-tdd-mindset-cover.png
  alt: "Glowing brain hologram above a keyboard with blue testing cycle lines"
---
Most developers learn TDD as "write tests before code" and stop there. This is shallow version. Real Test-Driven Development is not QA ritual. It is system design with executable feedback.

If you write the test after the code, you have missed the point. You already designed solution in your head, maybe badly, and now you ask test to applaud.

<!--more-->

## TDD Is Design Pressure

A good test forces you to answer important questions before implementation hides them.

What is input? What is output? What is error policy? What does this object own? Which dependency is real and which one should be outside boundary?

This pressure is uncomfortable. Good. Thinking before coding should be uncomfortable sometimes.

## Red: Write The Failure

Imagine we need service that blocks withdrawals over daily limit.

~~~java
class WithdrawalPolicyTest {
    @Test
    void rejectsWithdrawalWhenDailyLimitWouldBeExceeded() {
        WithdrawalPolicy policy = new WithdrawalPolicy(new BigDecimal("500.00"));

        Decision decision = policy.decide(
            new BigDecimal("450.00"),
            new BigDecimal("100.00")
        );

        assertThat(decision.allowed()).isFalse();
        assertThat(decision.reason()).isEqualTo("DAILY_LIMIT_EXCEEDED");
    }
}
~~~

This test probably does not compile. Perfect. Red is not failure of developer. Red is proof you found next design step.

## Green: Do Simple Thing

Now write smallest implementation that expresses behavior.

~~~java
record Decision(boolean allowed, String reason) {}

final class WithdrawalPolicy {
    private final BigDecimal dailyLimit;

    WithdrawalPolicy(BigDecimal dailyLimit) {
        this.dailyLimit = dailyLimit;
    }

    Decision decide(BigDecimal alreadyWithdrawn, BigDecimal requested) {
        BigDecimal total = alreadyWithdrawn.add(requested);
        if (total.compareTo(dailyLimit) > 0) {
            return new Decision(false, "DAILY_LIMIT_EXCEEDED");
        }
        return new Decision(true, "OK");
    }
}
~~~

No abstract factory. No policy engine. No event bus. Simple thing first, because simple thing is usually what survives production.

## Refactor: Improve Shape Without Changing Behavior

Now add null policy, currency scale, and maybe domain names. Tests protect you while structure improves.

~~~java
Decision decide(Money alreadyWithdrawn, Money requested) {
    Money total = alreadyWithdrawn.plus(requested);
    return total.isGreaterThan(dailyLimit)
        ? Decision.rejected("DAILY_LIMIT_EXCEEDED")
        : Decision.allowed();
}
~~~

Notice what happened. We did not guess architecture in advance. We let behavior pull better names and boundaries from code.

## What Beginners Get Wrong

They test implementation details. They mock everything. They assert that method A called method B, and then refactor breaks tests even when behavior is same.

Test public behavior at useful boundary. For backend Java this is often service method, controller with slice test, repository integration test, or pure domain object.

## TDD Is Not Religion

Do not TDD CSS color. Do not TDD one-time migration script if cost is higher than value. But for business rules, money movement, concurrency, parsing, security, and refactoring legacy logic, TDD is cheaper than bravery.

## The Real Mindset

Before you code, ask: what observable behavior would make me confident?

Write that. Watch it fail. Make it pass. Clean the design. Repeat.

This is boring loop. Boring loop builds serious systems.

## Related reading

- [No Tests, No Merge: Why I Reject Half of PRs](/blog/no-tests-no-merge-why-i-reject-half-of-prs/)
- [Refactoring Without Tests Is Just Guessing](/blog/refactoring-without-tests-is-just-guessing/)
