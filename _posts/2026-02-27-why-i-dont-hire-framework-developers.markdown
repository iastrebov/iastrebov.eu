---
layout: post
title: "Why I Do Not Hire Framework Developers"
date: 2026-02-27 23:18:00 +0000
categories: software engineering
tags: [hiring, java, spring-boot, fundamentals]
excerpt_separator: <!--more-->
greeting: "fundamentals before annotations"
description: "A controversial hiring post arguing that Spring Boot skills are not enough without HTTP, Java fundamentals, databases, and testing knowledge."
image:
  url: assets/images/blog/2026-02-27-why-i-dont-hire-framework-developers-cover.png
  alt: "Developer in Spring Boot shirt trying to fix a complex engine with one bent screwdriver"
---
I do not hire framework developers. I hire engineers who can use frameworks.

Difference is large. Framework developer knows which annotation to paste. Engineer knows what problem annotation hides.

<!--more-->

## Spring Boot Is Not Personality

Spring Boot is excellent. It removes boilerplate, standardizes configuration, and gets services running fast.

But if you can build CRUD app in five minutes and cannot explain HTTP status codes, transactions, thread pools, or how dependency injection works, you are not backend engineer. You are annotation operator.

## Magic Has Cost

Framework magic is compressed knowledge. Good engineer can decompress when needed.

What creates this bean? Why proxy exists? Is method transactional when called from same class? Which thread handles request? When is connection returned to pool?

If answer is "Spring does it", interview becomes short.

## Core Java Still Matters

You should understand collections, generics, exceptions, records, concurrency basics, memory, streams trade-offs, and object design.

Framework cannot save this:

~~~java
Map<String, BigDecimal> balances = new HashMap<>();

void add(String account, BigDecimal amount) {
    balances.put(account, balances.get(account).add(amount));
}
~~~

Null bug, race condition, no domain type, no validation. Annotation will not fix brain.

## HTTP Is Not Controller Decoration

Know idempotency. Know difference between 400 and 409. Know why POST retry is dangerous. Know caching headers enough not to embarrass yourself.

REST is not "put JSON here".

## Databases Are Not Repositories Only

You must understand indexes, transactions, isolation, migrations, connection pools, and query plans at useful level.

ORM is tool. If you never look at SQL, production will eventually invite you.

## What I Like In Candidates

Build something without framework once. Small HTTP server. JDBC query. Manual dependency wiring. Pure Java business logic with tests.

Then use Spring Boot and appreciate it. Fundamentals first, leverage second.

## Hiring Question

I ask: explain what happens from HTTP request hitting service to database commit. Strong candidate can draw path. Weak candidate names annotations.

## Final Rule

Framework knowledge is valuable. Framework dependence is weakness.

Learn foundations. Then framework becomes multiplier instead of crutch.

## Related reading

- [Java 25 Is Here: Why Your Java 8 Code Is an Embarrassment](/blog/java-25-is-here-why-your-java-8-code-is-an-embarrassment/)
- [Your Roadmap Is Wrong: Stop Learning Syntax, Start Building](/blog/your-roadmap-is-wrong-stop-learning-syntax-start-building/)
