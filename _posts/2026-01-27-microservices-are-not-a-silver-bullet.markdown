---
layout: post
title: "Microservices Are Not A Silver Bullet: You Probably Need A Monolith"
date: 2026-01-27 19:03:00 +0000
categories: software engineering
tags: [architecture, microservices, monolith, java]
excerpt_separator: <!--more-->
greeting: "distributed pain is still pain"
description: "A cynical but practical argument for modular monoliths over premature microservices, especially for startup Java backend systems."
image:
  url: assets/images/blog/2026-01-27-microservices-are-not-a-silver-bullet-cover.png
  alt: "Solid stone pyramid beside chaotic glass microservice spheres connected by wires"
---
Microservices are not architecture maturity badge. They are distributed systems. Distributed systems are where simple bugs wear expensive clothes.

Most startups asking for microservices need modular monolith, one database, strong tests, and fewer meetings.

<!--more-->

## The Hidden Bill

When you split one application into ten services, you did not remove complexity. You changed its address.

Now every function call can become network timeout. Every transaction becomes saga. Every log line needs correlation id. Every local refactor becomes versioned contract. Every deploy needs choreography.

Congratulations, you invented operations department before product-market fit.

## Microservices Solve Real Problems

They help when teams are independent, scaling needs differ, release cadences conflict, fault isolation is critical, and domain boundaries are stable enough to enforce.

Read that again: stable boundaries. Beginners split by nouns from first whiteboard: user-service, order-service, notification-service. Two months later every feature needs all of them.

That is not architecture. That is latency with YAML.

## Modular Monolith Is Not Big Ball Of Mud

A modular monolith has one deployable unit but clear internal boundaries.

~~~java
com.company.billing
com.company.ledger
com.company.customer
com.company.risk
~~~

Modules communicate through explicit interfaces. Database ownership is respected inside code. Tests enforce boundaries. You can split later when pain is real.

A bad monolith is uncontrolled coupling. A good monolith is simple operational model with disciplined code structure.

## Java Is Good At This

Java packages, modules, build boundaries, ArchUnit tests, Spring contexts, and clear domain services make modular monolith practical.

You can enforce rules:

~~~java
@AnalyzeClasses(packages = "com.company")
class ArchitectureTest {
    @ArchTest
    static final ArchRule ledgerDoesNotDependOnWeb = noClasses()
        .that().resideInAPackage("..ledger..")
        .should().dependOnClassesThat().resideInAPackage("..web..");
}
~~~

Now boundary is not diagram. It is test.

## When To Split

Split when one module has independent scaling pressure, independent data ownership, mature API contract, and team able to own it in production.

Do not split because conference talk had nice boxes.

## Beginner Trap

Developers underestimate network. Local method call fails rarely and immediately. Network call fails slowly, partially, and in ways that make dashboards interesting.

Retries duplicate side effects. Timeouts hide slow dependencies. Circuit breakers need tuning. Tracing must exist before incident, not after.

## My Default Advice

Start with modular monolith. Keep boundaries honest. Write tests. Use events inside process where helpful. Extract service only when operational or organizational pressure is stronger than distributed complexity.

Microservices are powerful tool. So is chainsaw. Beginners should not use chainsaw to cut sandwich.

## Related reading

- [Python Is For Scripts, Java Is For Business](/blog/python-is-for-scripts-java-is-for-business/)
- [10 Years In Big Tech: The Ugly Truth About Fintech](/blog/10-years-in-big-tech-ugly-truth-about-fintech/)
