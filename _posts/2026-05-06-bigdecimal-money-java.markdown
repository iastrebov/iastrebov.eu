---
layout: post
title: "BigDecimal For Money: The Java Rules That Prevent Quiet Corruption"
date: 2026-05-06 08:10:00 +0100
categories: software engineering
tags: [java, bigdecimal, money, fintech]
excerpt_separator: <!--more-->
greeting: "decimal arithmetic needs policy"
description: "Use BigDecimal for money in Java without scale drift, unsafe constructors, or equality traps that turn ordinary arithmetic into accounting defects."
image:
  url: assets/images/blog/2026-05-06-bigdecimal-money-java-cover.png
  alt: "A precise brass balance dividing decimal coins into exact currency columns"
---
`BigDecimal` does not make money code correct. It only gives you decimal arithmetic. You must still decide scale, rounding, currency, and equality.

Leave those decisions scattered across controllers and mappers, and one-cent disagreements will appear in the worst possible place: reconciliation.

<!--more-->

## Never Construct Money From A Double

This line stores the binary approximation already present in the `double`:

~~~java
BigDecimal fee = new BigDecimal(0.1);
System.out.println(fee);
// 0.1000000000000000055511151231257827021181583404541015625
~~~

Use a decimal string when the value is written by a human, or `BigDecimal.valueOf` when a `double` is unavoidable at a boundary.

~~~java
BigDecimal exact = new BigDecimal("0.10");
BigDecimal boundary = BigDecimal.valueOf(0.1);
~~~

Better still, do not let binary floating-point enter a money domain.

## Scale Is Part Of The Contract

EUR commonly travels with two fraction digits, but not every currency does. A percentage calculation can also create more digits than the final amount allows. Pick the rule at one boundary.

~~~java
record Money(Currency currency, BigDecimal amount) {
    Money {
        Objects.requireNonNull(currency, "currency");
        Objects.requireNonNull(amount, "amount");
        int scale = currency.getDefaultFractionDigits();
        amount = amount.setScale(scale, RoundingMode.UNNECESSARY);
    }

    Money percentage(BigDecimal rate, RoundingMode rounding) {
        return new Money(currency,
            amount.multiply(rate).setScale(currency.getDefaultFractionDigits(), rounding));
    }
}
~~~

`UNNECESSARY` is deliberately strict at construction. It rejects an amount that already needs rounding. The operation that creates extra precision must name its rounding mode instead of smuggling one through a mapper.

## Equals And CompareTo Disagree

`new BigDecimal("10.0").equals(new BigDecimal("10.00"))` is false because `equals` includes scale. `compareTo` returns zero because the numeric values match.

This matters in tests, sets, and entity keys. Decide whether scale is domain data. If `10.0 EUR` is invalid because your contract requires two digits, normalize at construction. If scale is irrelevant, compare numerically and do not use raw `BigDecimal` as a hash key.

## Division Must Name Rounding

~~~java
BigDecimal third = BigDecimal.ONE.divide(new BigDecimal("3"));
// ArithmeticException: non-terminating decimal expansion
~~~

The exception is useful. Java refuses to guess. Give the operation a precision or final scale based on a business rule, not because `HALF_UP` looked familiar.

~~~java
BigDecimal allocated = total.divide(parts, 2, RoundingMode.DOWN);
BigDecimal remainder = total.subtract(allocated.multiply(parts));
~~~

Now the remainder is visible. You still need a policy for assigning it. Financial arithmetic always leaves policy somewhere; good code makes location obvious.

## Put Currency Beside Amount

A naked `BigDecimal` parameter invites accidental addition of EUR to USD. Wrap the pair and reject mixed arithmetic.

The hard part of money is not multiplication. It is preserving meaning while values cross JSON, database columns, provider APIs, and reports. Make one `Money` type own that meaning, then test boundary values and rounding residue.


- [Idempotency: How Not To Charge A Client Twice](/blog/idempotency-how-not-to-charge-a-client-twice/)
- [Database Locks: The Silent Killer Of High-Load Systems](/blog/database-locks-silent-killer-high-load-systems/)
