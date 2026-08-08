---
layout: post
title: "Java Generics Variance: PECS Without The Parrot Lesson"
date: 2026-05-10 16:30:00 +0100
categories: software engineering
tags: [java, generics, type-system, api-design]
excerpt_separator: <!--more-->
greeting: "types describe safe movement"
description: "Understand Java generic invariance, producer and consumer bounds, wildcard capture, and how to design collection APIs without unsafe casts."
image:
  url: assets/images/blog/2026-05-10-java-generics-variance-cover.png
  alt: "Typed containers moving safely through one-way producer and consumer gates"
---
`List<Integer>` is not a subtype of `List<Number>`. Beginners see needless restriction. The compiler sees the `Double` you could otherwise add to a list of integers.

Variance is not academic decoration. It describes which direction values may move safely through an API.

<!--more-->

## Why Lists Are Invariant

Imagine this compiled:

~~~java
List<Integer> integers = new ArrayList<>();
List<Number> numbers = integers;
numbers.add(3.14);
Integer value = integers.get(0);
~~~

The last line would retrieve a `Double` as an `Integer`. Java rejects the assignment earlier.

Arrays made a different historical choice: they are covariant and fail at runtime with `ArrayStoreException`. Generics move that failure to compilation.

## Extends Means Read A Common Type

~~~java
double sum(List<? extends Number> values) {
    double result = 0;
    for (Number value : values) {
        result += value.doubleValue();
    }
    return result;
}
~~~

The method accepts `List<Integer>`, `List<Long>`, or `List<BigDecimal>`. It can read each element as `Number`. It cannot safely add an `Integer`, because the actual list may be `List<Double>`.

This is the producer half of PECS: producer extends.

## Super Means Write A Specific Type

~~~java
void addDefaults(List<? super Integer> target) {
    target.add(0);
    target.add(1);
}
~~~

The target can be `List<Integer>`, `List<Number>`, or `List<Object>`. Reading gives only `Object`, because that is the only type guaranteed.

This is consumer super.

The mnemonic is useful only after mechanism is clear. Do not chant PECS over every type parameter. If a collection is both read and written as the exact same type, use `List<T>`.

## Prefer Type Parameters When Types Relate

Wildcards describe one flexible position. A type parameter connects positions.

~~~java
static <T> void copy(
        List<? extends T> source,
        List<? super T> target) {
    for (T item : source) {
        target.add(item);
    }
}
~~~

Here `T` explains the relationship between input and output. Replacing it with unrelated wildcards would lose that constraint.

## Wildcard Capture Is A Helper Problem

Sometimes `List<?>` is correct at public boundary, but an operation needs one consistent hidden type. A private generic helper can capture it. Do not reach for raw types or casts just to silence the compiler.

Raw `List` means “stop checking.” `List<?>` means “the element type exists but is unknown here.” These are not same promise.

Good generic APIs make invalid movement impossible. When a signature becomes a wall of bounds, step back: perhaps the abstraction is trying to serve too many directions at once.


- [Java Records: You're Still Writing Boilerplate?](/blog/java-records-youre-still-writing-boilerplate/)
- [How To Read Documentation Like A Senior Engineer](/blog/how-to-read-documentation-like-a-senior-engineer/)
