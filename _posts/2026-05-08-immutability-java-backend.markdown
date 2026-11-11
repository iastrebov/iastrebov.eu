---
layout: post
title: "Immutability In Java: Fewer States, Fewer Production Surprises"
date: 2026-05-08 07:40:00 +0100
categories: software engineering
tags: [java, immutability, concurrency, domain-design]
excerpt_separator: <!--more-->
greeting: "make illegal change impossible"
description: "Use Java immutability to shrink state space, protect collection boundaries, and make concurrent backend code easier to reason about."
image:
  url: assets/images/blog/2026-05-08-immutability-java-backend-cover.png
  alt: "A sealed crystal data structure protected from branching mutation paths"
---
Mutable objects are cheap to create and expensive to understand. Any method holding a reference may change them, sometimes long after the code you are reading.

Immutability removes those hidden timelines. It is not fashion. It is a reduction in possible states.

<!--more-->

## Final Fields Are Only The First Layer

This class is not immutable:

~~~java
final class Quote {
    private final List<BigDecimal> prices;

    Quote(List<BigDecimal> prices) {
        this.prices = prices;
    }

    List<BigDecimal> prices() {
        return prices;
    }
}
~~~

The caller can mutate the input list or the list returned by `prices()`.

~~~java
record Quote(List<BigDecimal> prices) {
    Quote {
        prices = List.copyOf(prices);
    }
}
~~~

`List.copyOf` closes both doors for an ordinary immutable element type. A record alone does not. Records prevent reassignment of components; they do not freeze objects behind those references.

## Model A Transition As A New Value

For a small domain object, return the next state instead of exposing setters.

~~~java
record Limit(BigDecimal used, BigDecimal maximum) {
    Limit reserve(BigDecimal amount) {
        BigDecimal next = used.add(amount);
        if (next.compareTo(maximum) > 0) {
            throw new LimitExceededException(maximum, next);
        }
        return new Limit(next, maximum);
    }
}
~~~

The invariant lives beside the transition. Nobody can call `setUsed` and bypass it.

This pattern is not free for a giant object graph. Rebuilding thousands of nodes can allocate heavily. Most request and domain objects are nowhere near that scale, so do not invent performance objection before profiling.

## Concurrency Becomes Smaller Problem

An immutable value can be shared between threads without locks for its own state. You may still need coordination around which version is current, but readers cannot observe half-written fields.

That distinction matters. An `AtomicReference<Configuration>` that swaps complete immutable snapshots is much easier to reason about than twenty mutable fields updated in sequence.

## Entities Need Controlled Mutation

JPA entities have lifecycle and identity. Forcing complete immutability can fight the persistence tool. The useful target is not “every class is record.” The useful target is no arbitrary mutation.

Give an entity methods such as `approve`, `cancel`, or `changeAddress`. Keep setters private or absent. Validate transitions inside those methods. Return immutable DTOs at the API boundary.

## Look For Reference Leaks

During review, inspect constructors and accessors for arrays, lists, maps, dates, and mutable third-party types. A defensive copy at one boundary is often enough.

Immutability buys local reasoning: read constructor, read operations, know the possible values. In a backend full of retries and concurrent requests, local reasoning is valuable currency.


- [Java Records: You're Still Writing Boilerplate?](/blog/java-records-youre-still-writing-boilerplate/)
- [Master Structured Concurrency In Java 25](/blog/master-structured-concurrency-in-java-25/)
