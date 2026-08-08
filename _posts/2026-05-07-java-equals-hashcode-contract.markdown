---
layout: post
title: "Java equals And hashCode: One Broken Contract, Many Missing Objects"
date: 2026-05-07 18:25:00 +0100
categories: software engineering
tags: [java, collections, equals, debugging]
excerpt_separator: <!--more-->
greeting: "hash maps remember your mistakes"
description: "Understand the Java equals and hashCode contract, mutable-key failures, inheritance traps, and why an object can vanish inside a HashMap."
image:
  url: assets/images/blog/2026-05-07-java-equals-hashcode-contract-cover.png
  alt: "Identical metal keys entering mismatched hash-map compartments in a mechanical cabinet"
---
An object can be inside a `HashSet` and still be impossible to find. No race condition is required. A mutable key and a careless `hashCode` are enough.

This bug feels supernatural only until you follow the collection algorithm.

<!--more-->

## What HashMap Actually Needs

`HashMap` uses the key hash to choose a bucket, then uses equality to find the key inside that bucket. Equal objects must therefore have equal hash codes.

~~~java
record AccountId(String value) {
    AccountId {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException("account id is required");
        }
    }
}
~~~

A record derives both methods from the same components, which is excellent for a value object.

The classic mistake overrides only `equals`:

~~~java
final class CustomerId {
    private final String value;

    @Override
    public boolean equals(Object other) {
        return other instanceof CustomerId id && value.equals(id.value);
    }
    // inherited identity-based hashCode: contract is broken
}
~~~

Two IDs compare equal but can land in different buckets. Lookup then never reaches the equal object.

## Never Mutate A Key In Place

Even correct methods fail when fields used by them change after insertion.

~~~java
var key = new ArrayList<>(List.of("ledger", "eu"));
var owners = new HashMap<List<String>, String>();
owners.put(key, "payments");

key.add("v2");
System.out.println(owners.get(key)); // often null
~~~

The entry remains in the bucket chosen for the old list contents. The new hash points elsewhere.

Use immutable keys. Copy a collection before storing it, or model the key as an immutable value type.

## Inheritance Makes Equality Political

Suppose `Money` compares currency and amount, while `DiscountedMoney` adds a discount code. Should base value equal subclass value? If one direction says yes and the other says no, symmetry is broken. If equality changes across a chain, transitivity can break too.

Value objects usually work better as final classes or records. Entity equality needs another decision: database ID, stable business ID, or object identity before persistence. There is no annotation that can choose this correctly for your lifecycle.

## Test The Contract, Not One Example

At minimum, test reflexivity, symmetry, transitivity, null handling, and equal hash codes. Property-based tests are useful because they generate more combinations than a polite hand-picked example.

~~~java
assertThat(a).isEqualTo(b);
assertThat(b).isEqualTo(a);
assertThat(a.hashCode()).isEqualTo(b.hashCode());
~~~

Also test collection behavior directly. Put one instance into a set and look it up with another equal instance.

When an object “disappears” from a hash collection, do not stare at the debugger for one hour. Check whether the key changed and whether equality and hashing use the same stable state.


- [Java Records: You're Still Writing Boilerplate?](/blog/java-records-youre-still-writing-boilerplate/)
- [Null Is Not An Option: Use Optional Or Fail](/blog/null-is-not-an-option-use-optional-or-fail/)
