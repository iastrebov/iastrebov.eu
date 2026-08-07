---
layout: post
title: "Why I Ban Mockito In My Teams"
date: 2026-05-03 13:18:00 +0100
categories: software engineering
tags: [testing, mockito, testcontainers, java]
excerpt_separator: <!--more-->
greeting: "real dependencies beat fake comfort"
description: "A deliberately strict testing post arguing against heavy Mockito usage and for Testcontainers-backed integration tests in Java services."
image:
  url: assets/images/blog/2026-05-03-why-i-ban-mockito-in-my-teams-cover.png
  alt: "Broken mock mannequins in a graveyard with a real glowing database engine descending"
---
Mockito is useful library. I still ban heavy Mockito culture in teams.

Because once developers discover mock everything, tests stop checking behavior and start checking choreography. Then every refactor breaks tests while production bugs walk through front door.

<!--more-->

## The Mocking Addiction

Bad unit test:

~~~java
verify(repository).save(order);
verify(eventPublisher).publish(any(OrderCreated.class));
~~~

Maybe order is invalid. Maybe transaction rolls back. Maybe database constraint fails. Test does not know. It only watches actors touch props.

This is fragile and shallow.

## What I Want Instead

For real persistence and messaging boundaries, run real dependency locally in test.

Testcontainers makes this practical.

~~~java
@Testcontainers
class PaymentRepositoryTest {
    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine");

    @DynamicPropertySource
    static void datasource(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", postgres::getJdbcUrl);
        registry.add("spring.datasource.username", postgres::getUsername);
        registry.add("spring.datasource.password", postgres::getPassword);
    }

    @Test
    void enforcesIdempotencyKeyUniqueness() {
        repository.insert("key-1", new BigDecimal("10.00"));

        assertThatThrownBy(() -> repository.insert("key-1", new BigDecimal("10.00")))
            .isInstanceOf(DuplicateKeyException.class);
    }
}
~~~

Now test checks real database behavior. This is more valuable than fifty fake verifications.

## Unit Tests Still Exist

Pure domain logic should be unit-tested fast without Spring, database, or Docker.

~~~java
assertThat(policy.canWithdraw(balance, amount)).isTrue();
~~~

No mock needed.

## When Mocks Are Fine

Mock external paid API. Mock time. Mock slow unreliable partner. Mock boundary you do not own.

But if you mock your own repository, your own mapper, your own service, your own validator, what remains? A puppet show.

## Refactor Resistance

Good tests survive internal refactor. Mock-heavy tests often fail because method call changed, not behavior.

This makes developers afraid to improve design. Test suite becomes cage.

## Final Rule

I do not ban Mockito jar. I ban Mockito thinking.

Use mocks as scalpel, not wallpaper. For serious backend, real database in tests is not luxury. It is adulthood.

## Related reading

- [Stop Coding, Start Thinking: The True TDD Mindset](/blog/stop-coding-start-thinking-tdd-mindset/)
- [Your 100% Test Coverage Is A Lie](/blog/your-100-percent-test-coverage-is-a-lie/)
