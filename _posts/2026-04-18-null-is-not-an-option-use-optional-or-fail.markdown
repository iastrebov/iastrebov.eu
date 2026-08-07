---
layout: post
title: "Null Is Not An Option: Use Optional Or Fail"
date: 2026-04-18 07:44:00 +0100
categories: software engineering
tags: [java, null-safety, optional, reliability]
excerpt_separator: <!--more-->
greeting: "make absence explicit"
description: "A hardcore Java null-safety guide showing why null returns cause outages and how Optional and explicit failures make code safer."
image:
  url: assets/images/blog/2026-04-18-null-is-not-an-option-use-optional-or-fail-cover.png
  alt: "Black null void swallowing a glowing line of code while red alarms flash"
---
Null is billion-dollar footgun with tiny syntax. Modern Java gives better options, and still teams return null like it is 2006.

If absence is valid, model it. If absence is invalid, fail loudly. Do not leave trap on floor for next developer.

<!--more-->

## Old Style Null Soup

~~~java
Customer customer = repository.findById(id);
if (customer != null) {
    Address address = customer.address();
    if (address != null) {
        send(address.email());
    }
}
~~~

Every line asks permission from void. Business rule is hidden under defensive noise.

Worse version skips one check and high-load system starts throwing <code>NullPointerException</code> only for rare imported accounts.

## Use Optional For Possible Absence

~~~java
Optional<Customer> findById(CustomerId id) {
    return jdbc.query(...).stream().findFirst();
}

Customer customer = repository.findById(id)
    .orElseThrow(() -> new UnknownCustomerException(id));
~~~

Now caller must decide. This is good pressure.

Do not use Optional for fields in JPA entities. Do not use Optional parameter for every method. Use it mainly for return values where absence is normal.

## Fail For Impossible Absence

Constructor should reject invalid state.

~~~java
record TransferCommand(AccountId from, AccountId to, Money amount) {
    TransferCommand {
        Objects.requireNonNull(from, "from");
        Objects.requireNonNull(to, "to");
        Objects.requireNonNull(amount, "amount");
        if (amount.isZeroOrNegative()) {
            throw new IllegalArgumentException("amount must be positive");
        }
    }
}
~~~

Now service does not need guess if command is valid.

## Pattern Matching Helps Readability

~~~java
String describe(Object value) {
    if (value instanceof AccountId id) {
        return "account " + id.value();
    }
    if (value instanceof Money money) {
        return "amount " + money;
    }
    return "unknown";
}
~~~

Modern Java makes type checks clearer. It does not make null safe automatically. You still design absence.

## Do Not Abuse Optional

Bad:

~~~java
Optional<Optional<Customer>> customer;
~~~

Also bad: <code>optional.get()</code> because you were too lazy to model path.

Use <code>map</code>, <code>flatMap</code>, <code>orElseThrow</code>, and clear domain exceptions.

## Final Rule

Null should be rare and contained at boundaries: database driver, JSON parser, old API.

Inside domain, absence is explicit or impossible. Anything else is delayed incident.

## Related reading

- [Java 25 Is Here: Why Your Java 8 Code Is an Embarrassment](/blog/java-25-is-here-why-your-java-8-code-is-an-embarrassment/)
- [The $1 Million Bug: A Junior's Nightmare](/blog/one-million-dollar-bug-juniors-nightmare/)
