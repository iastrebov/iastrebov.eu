---
layout: post
title: "Your 100% Test Coverage Is A Lie"
date: 2026-04-29 19:24:00 +0100
categories: software engineering
tags: [testing, java, coverage, integration-tests]
excerpt_separator: <!--more-->
greeting: "coverage is not confidence"
description: "Why 100% test coverage can still hide broken behavior, fake mocks, and production failures that integration tests would catch."
image:
  url: assets/images/blog/2026-04-29-your-100-percent-test-coverage-is-a-lie-cover.png
  alt: "Crumbling golden 100 percent coverage trophy with rusty gears inside"
---
100% test coverage can be a beautiful lie. It looks serious in dashboard. It gives manager nice green number. It says almost nothing about whether your system works.

Coverage tells you which lines executed. It does not tell you whether behavior was verified, SQL was correct, dependencies were real, or business rule survived production data.

<!--more-->

## Line Coverage Is Not Confidence

A bad test can execute every line and prove nothing.

When team starts chasing coverage percentage, tests become decoration. Developers mock everything, assert implementation details, and celebrate because report is green.

This is not engineering. This is metric cosplay.

## The Mocked Test That Lies

Here is repository method with broken SQL.

~~~java
class PaymentRepository {
    private final JdbcTemplate jdbc;

    List<Payment> findSettledPayments(LocalDate day) {
        return jdbc.query("""
            select id, amount, status
            from payments
            where settled_at = ? and state = 'SETLED'
            """, paymentRowMapper(), day);
    }
}
~~~

Typo: <code>SETLED</code>. Maybe production column is <code>status</code>, not <code>state</code>. Your mocked service test will not care.

~~~java
@Test
void returnsSettledPayments() {
    PaymentRepository repository = mock(PaymentRepository.class);
    when(repository.findSettledPayments(LocalDate.parse("2026-04-29")))
        .thenReturn(List.of(new Payment("p1", new BigDecimal("10.00"))));

    PaymentReport report = new PaymentReport(repository);

    assertThat(report.totalFor(LocalDate.parse("2026-04-29")))
        .isEqualByComparingTo("10.00");
}
~~~

Congratulations. You tested Mockito, not database behavior.

## What Real Verification Looks Like

Use integration tests for persistence boundaries.

~~~java
@Test
void findsSettledPaymentsForDay() {
    jdbc.update("insert into payments(id, amount, status, settled_at) values (?, ?, ?, ?)",
        "p1", new BigDecimal("10.00"), "SETTLED", LocalDate.parse("2026-04-29"));

    List<Payment> result = repository.findSettledPayments(LocalDate.parse("2026-04-29"));

    assertThat(result).extracting(Payment::id).containsExactly("p1");
}
~~~

This catches broken SQL. Mock does not.

## Mocks Are Not Evil

Mock external payment provider. Mock slow email gateway. Mock clock when time matters.

Do not mock your domain until test has no reality left. Do not mock repository when the whole risk is query correctness. Do not mock object just because it is easy.

## Coverage Target Is Floor, Not Trophy

Coverage can reveal untested code. Useful. But high number must trigger second question: what kind of tests create this number?

If 100% coverage is mostly mocks and getters, it is hollow trophy.

## Better Metrics

Track mutation testing for core logic. Track integration coverage around database and API. Track escaped defects. Track time to detect regressions. Track tests that fail when business rule breaks.

Production does not care about line percentage. Production cares about behavior.

## Final Rule

Use coverage as smoke alarm, not scoreboard.

A strict engineer asks: what bug would this test catch? If answer is "not sure", delete or rewrite it.

## Related reading

- [No Tests, No Merge: Why I Reject Half of PRs](/blog/no-tests-no-merge-why-i-reject-half-of-prs/)
- [Stop Coding, Start Thinking: The True TDD Mindset](/blog/stop-coding-start-thinking-tdd-mindset/)
- [Why I Ban Mockito In My Teams](/blog/why-i-ban-mockito-in-my-teams/)
