---
layout: post
title: "Validation Boundaries In Spring: DTO Checks Are Not Domain Rules"
date: 2026-05-19 11:40:00 +0100
categories: software engineering
tags: [spring, validation, domain-design, api]
excerpt_separator: <!--more-->
greeting: "validate syntax and meaning separately"
description: "Separate request-shape validation from domain invariants and database constraints in a Spring API without duplicating rules blindly."
image:
  url: assets/images/blog/2026-05-19-validation-boundaries-spring-api-cover.png
  alt: "Three validation gates checking request shape, domain rules, and database invariants"
---
`@NotBlank` can prove a field contains characters. It cannot prove an account may transfer money now.

Treat all validation as controller decoration and business rules leak through every other entry point: jobs, message consumers, admin tools, and tests.

<!--more-->

## Boundary Validation Protects Parsing

Request DTOs should reject malformed shape and cheap local constraints.

~~~java
record TransferRequest(
    @NotBlank String source,
    @NotBlank String target,
    @DecimalMin("0.01") BigDecimal amount,
    @NotBlank String currency
) {}
~~~

This produces fast client feedback. It does not know account state, exchange rules, daily limits, or whether the source exists.

## Domain Objects Protect Meaning

Convert the DTO into domain types that cannot represent obvious nonsense.

~~~java
record Transfer(AccountId source, AccountId target, Money amount) {
    Transfer {
        if (source.equals(target)) {
            throw new InvalidTransfer("source and target must differ");
        }
    }
}
~~~

Rules depending on current state belong in a policy or aggregate operation: sufficient balance, account status, per-day limits.

## Database Constraints Close The Race

Application validation cannot replace a unique constraint, foreign key, check constraint, or optimistic version. State can change between “is this available?” and insert.

Use the database to enforce invariants it can own, then translate constraint violations into a stable domain outcome. A pre-check may improve error wording, but the constraint remains referee.

## Avoid Three Copies Of One Rule

Duplication is justified only when layers protect different things. A maximum field length in DTO and column schema may be deliberate. The domain should not repeat it unless length has business meaning.

Ask what each check defends, who can bypass it, and what race remains. Validation is layered defense, not annotation collection.


- [Null Is Not An Option: Use Optional Or Fail](/blog/null-is-not-an-option-use-optional-or-fail/)
- [No Tests, No Merge: The Evidence A Pull Request Owes You](/blog/no-tests-no-merge-why-i-reject-half-of-prs/)
