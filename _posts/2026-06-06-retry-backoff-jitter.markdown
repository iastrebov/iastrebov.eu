---
layout: post
title: "Retry Backoff And Jitter: Stop Recreating The Outage In Waves"
date: 2026-06-06 17:35:00 +0100
categories: software engineering
tags: [distributed-systems, retries, backoff, reliability]
excerpt_separator: <!--more-->
greeting: "synchronized recovery is another failure"
description: "Build bounded retry backoff with jitter, deadlines, idempotency, and overload signals instead of sending synchronized retry storms."
image:
  url: assets/images/blog/2026-06-06-retry-backoff-jitter-cover.png
  alt: "Synchronized retry waves spread into randomized smaller pulses before a recovering service"
---
When one dependency fails, thousands of callers often wait the same delay and retry at the same instant. The service begins to recover, then the synchronized wave knocks it down again.

<!--more-->

## Exponential Is Not Enough

A common schedule grows delays: 100 ms, 200 ms, 400 ms. Without randomness, every caller starting together stays together.

Full jitter chooses a random delay between zero and the current cap:

~~~java
long cap = Math.min(maxDelayMs, baseDelayMs << attempt);
long delay = ThreadLocalRandom.current().nextLong(cap + 1);
~~~

Other jitter algorithms trade spread against predictability. The exact formula matters less than avoiding a synchronized fleet.

## Bound Attempts And Total Time

Attempt count alone is weak. Five retries with long timeouts may occupy a request for minutes. Stop when the operation deadline expires.

Honor server hints such as `Retry-After` when the contract provides them. Do not retry overload responses immediately because your client feels urgent.

## Retry The Smallest Safe Unit

Repeating a whole workflow can duplicate earlier successful steps. Retry a specific idempotent call, or persist workflow state and resume from a known step.

Expose retry volume and recovered-versus-final failures. A dependency requiring retries for every request is degraded even if customer responses remain green.

Backoff gives recovery space. Jitter prevents a crowd from using that space on the same millisecond.


- [Spring Retry Can Duplicate Side Effects: Annotate With Suspicion](/blog/spring-retry-duplicate-side-effects/)
- [Idempotency: How Not To Charge A Client Twice](/blog/idempotency-how-not-to-charge-a-client-twice/)
