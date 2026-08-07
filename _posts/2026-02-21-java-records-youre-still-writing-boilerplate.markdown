---
layout: post
title: "Java Records: You're Still Writing Boilerplate?"
date: 2026-02-21 14:26:00 +0000
categories: software engineering
tags: [java, records, dto, modern-java]
excerpt_separator: <!--more-->
greeting: "delete the getters"
description: "A modern Java tutorial showing how records replace DTO boilerplate, reduce Lombok dependency, and make immutable API models obvious."
image:
  url: assets/images/blog/2026-02-21-java-records-youre-still-writing-boilerplate-cover.png
  alt: "Laser vaporizing a mountain of boilerplate paper documents"
---
If you still write DTOs with fields, getters, setters, equals, hashCode, and toString by hand, I have news from last decade: Java moved.

Records exist. Use them.

<!--more-->

## Old Boilerplate

~~~java
public class CustomerResponse {
    private final String id;
    private final String name;

    public CustomerResponse(String id, String name) {
        this.id = id;
        this.name = name;
    }

    public String getId() { return id; }
    public String getName() { return name; }
}
~~~

This is not business code. This is typing exercise.

## Record Version

~~~java
public record CustomerResponse(String id, String name) {}
~~~

Done. Constructor, accessors, equals, hashCode, toString. Immutable by default for references, assuming referenced objects are handled responsibly.

## Validate In Compact Constructor

~~~java
public record CreateAccountRequest(String ownerName, String currency) {
    public CreateAccountRequest {
        if (ownerName == null || ownerName.isBlank()) {
            throw new IllegalArgumentException("ownerName is required");
        }
        Currency.getInstance(currency);
    }
}
~~~

Now DTO can protect itself from nonsense.

## Lombok Is Less Needed

Lombok was useful when Java was noisy. But if you use Lombok for simple immutable data carriers in modern Java, ask why.

Annotation processor magic can confuse tools, hide generated behavior, and make onboarding harder. Records are language feature. Prefer language feature.

## Records Are Not Entities

Do not blindly use records for JPA entities. ORM needs identity, lifecycle, proxies, and sometimes no-arg constructor. Records are best for DTOs, value objects, messages, API responses, configuration.

Use tool where it fits.

## Better API Contracts

~~~java
public record TransferResponse(
    String transferId,
    String status,
    BigDecimal amount,
    Instant createdAt
) {}
~~~

Shape is obvious. No setter means response cannot be half-mutated by mapper mistake.

## Final Rule

Stop writing ceremonial Java and then complaining Java is verbose.

Modern Java gives you records. Use them where data is data, and spend attention on behavior that matters.

## Related reading

- [Java 25 Is Here: Why Your Java 8 Code Is an Embarrassment](/blog/java-25-is-here-why-your-java-8-code-is-an-embarrassment/)
- [Why I Do Not Hire Framework Developers](/blog/why-i-dont-hire-framework-developers/)
