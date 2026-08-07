---
layout: post
title: "Refactoring Without Tests Is Just Guessing"
date: 2026-04-04 11:47:00 +0100
categories: software engineering
tags: [refactoring, tests, legacy-code, java]
excerpt_separator: <!--more-->
greeting: "legacy horror story"
description: "A legacy-code horror story showing why characterization tests must come before refactoring critical financial modules."
image:
  url: assets/images/blog/2026-04-04-refactoring-without-tests-is-just-guessing-cover.png
  alt: "Blindfolded developer crossing a tightrope over a dark abyss with a laptop"
---
Junior developer opens legacy payment module and says: "This code is ugly. I will clean it." Famous last words.

By evening code is prettier. By morning settlement numbers are wrong. This is how refactoring without tests becomes guessing with confidence.

<!--more-->

## The Horror Scene

Old code:

~~~java
BigDecimal calculateFee(Account account, BigDecimal amount) {
    if (account.type().equals("VIP")) {
        return amount.multiply(new BigDecimal("0.01"));
    }
    if (amount.compareTo(new BigDecimal("1000")) > 0) {
        return amount.multiply(new BigDecimal("0.02"));
    }
    return amount.multiply(new BigDecimal("0.03"));
}
~~~

It is ugly. Strings for type. Magic numbers. No rounding. But it has one important quality: production depends on its exact weirdness.

Junior rewrites to elegant enum and accidentally changes priority of rules. VIP with amount over 1000 now pays 2% instead of 1%. Tiny diff. Expensive diff.

## First Write Characterization Test

A characterization test captures what system does now, even if behavior is strange.

~~~java
class FeeCharacterizationTest {
    private final LegacyFeeService service = new LegacyFeeService();

    @Test
    void vipAlwaysUsesVipRateEvenForLargeAmount() {
        Account vip = new Account("VIP");

        BigDecimal fee = service.calculateFee(vip, new BigDecimal("2000.00"));

        assertThat(fee).isEqualByComparingTo(new BigDecimal("20.0000"));
    }

    @Test
    void regularLargeAmountUsesLargeAmountRate() {
        Account regular = new Account("REGULAR");

        BigDecimal fee = service.calculateFee(regular, new BigDecimal("2000.00"));

        assertThat(fee).isEqualByComparingTo(new BigDecimal("40.0000"));
    }
}
~~~

Do not argue yet. Document current reality. Production reality beats your taste.

## Then Refactor Under Safety Net

Now improve structure while tests stay green.

~~~java
BigDecimal calculateFee(Account account, BigDecimal amount) {
    Rate rate = switch (account.type()) {
        case "VIP" -> Rate.VIP;
        default -> amount.compareTo(LARGE_AMOUNT) > 0 ? Rate.LARGE : Rate.STANDARD;
    };
    return rate.apply(amount);
}
~~~

If behavior changes, test catches it immediately. Then you decide intentionally: preserve weird rule, or change it with product sign-off and new test.

## Refactoring Means No Behavior Change

Changing behavior and cleaning code in same PR is how incidents are born. Separate them.

First PR: characterization tests. Second PR: refactor with same behavior. Third PR: behavior change with business approval. This feels slower only to people who never paid rollback cost.

## Legacy Code Is Negotiation

Bad old code often contains hidden business decisions. Maybe VIP priority exists because contract with partner. Maybe rounding bug is now depended upon by monthly report. Maybe null means imported account.

You do not know. Tests help you ask better questions.

## Proper Approach

Find critical path. Add tests around externally visible behavior. Cover boundaries and weird samples from production logs. Refactor one small step. Run tests. Repeat.

Do not rewrite whole module because your IDE offered extraction menu.

## Final Warning

Pretty code that loses money is worse than ugly code that works.

Your job is not to satisfy aesthetic hunger. Your job is to improve system without breaking contract. Tests are how you know difference.

## Related reading

- [No Tests, No Merge: Why I Reject Half of PRs](/blog/no-tests-no-merge-why-i-reject-half-of-prs/)
- [Stop Coding, Start Thinking: The True TDD Mindset](/blog/stop-coding-start-thinking-tdd-mindset/)
