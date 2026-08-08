---
layout: post
title: "Hexagonal Architecture In Java: Ports Must Earn Their Names"
date: 2026-05-24 13:35:00 +0100
categories: software engineering
tags: [java, architecture, testing, spring]
excerpt_separator: <!--more-->
greeting: "boundaries before folder diagrams"
description: "Apply hexagonal architecture to Java by isolating volatile boundaries and business policy without creating an interface for every class."
image:
  url: assets/images/blog/2026-05-24-hexagonal-architecture-java-cover.png
  alt: "A compact hexagonal core connected to database and HTTP adapters through explicit ports"
---
Hexagonal architecture is often introduced as a folder tree with `domain`, `application`, `ports`, and `adapters`. Teams copy it, create forty one-method interfaces, and declare victory.

A boundary earns its place when it protects policy from a volatile detail.

<!--more-->

## Start With One Use Case

~~~java
final class ReserveFunds {
    private final Accounts accounts;
    private final Reservations reservations;

    ReservationId execute(ReserveCommand command) {
        Account account = accounts.load(command.accountId());
        Reservation reservation = account.reserve(command.amount());
        return reservations.save(reservation);
    }
}
~~~

`Accounts` and `Reservations` are ports if the use case should not know JDBC, JPA, HTTP, or an in-memory test implementation. The domain operation remains ordinary Java.

Spring wiring belongs outside this core. An adapter can implement the port with JPA. A controller can convert JSON into a command.

## Do Not Abstract Stable Language Features

An interface around every utility, mapper, and value object adds navigation without isolation. “We may replace it later” is not enough. Name the concrete volatility: database technology, external provider, clock, message publication, filesystem.

## Test At Different Seams

Pure policy tests run without Spring. Adapter integration tests prove SQL and mapping. A smaller set of end-to-end tests proves wiring.

This is the real payoff: tests select the boundary appropriate to the risk. Mocking every internal class is not hexagonal architecture. It is fear of objects touching.

If the architecture diagram has many ports but a business rule still lives in a controller annotation callback, the folders are lying. Trace a use case from input to state change; the policy should remain readable without framework archaeology.


- [Microservices Are Not A Silver Bullet: You Probably Need A Monolith](/blog/microservices-are-not-a-silver-bullet/)
- [Why I Do Not Hire Framework Developers](/blog/why-i-dont-hire-framework-developers/)
