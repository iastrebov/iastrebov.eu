---
layout: post
title: "API Idempotency Keys: The Same Key Must Mean The Same Request"
date: 2026-06-23 19:25:00 +0100
categories: software engineering
tags: [api, idempotency, payments, reliability]
excerpt_separator: <!--more-->
greeting: "operation identity needs a contract"
description: "Design public API idempotency keys with request fingerprints, durable response replay, scoped uniqueness, concurrent claims, and retention rules."
image:
  url: assets/images/blog/2026-06-23-api-idempotency-keys-cover.png
  alt: "One idempotency key opening a stored response while a mismatched request is rejected"
---
If a client reuses one idempotency key with a different amount, returning the first success is not idempotency. It is silently accepting a contradiction.

<!--more-->

## Bind Key To Request Meaning

Store a canonical fingerprint of fields that define the operation. On replay, compare it with the original. Same key plus different meaning should return a conflict.

Do not hash volatile headers, whitespace, or fields the server legitimately defaults unless they affect business identity.

## Claim Before The Side Effect

Insert a processing record under a unique `(client_id, key)` constraint. Concurrent requests race there, not at provider call. The winner continues; the loser reads current state or receives a processing response.

Store the final status and enough response data to replay deterministically. A process crash after remote success but before local completion still needs reconciliation.

## Publish Retention

Keys cannot live forever for free. Define how long the server remembers them and how clients behave after expiry. The window must cover realistic retries, delayed jobs, and provider recovery.

Scope prevents one tenant from colliding with another. Entropy prevents accidental reuse. Neither replaces payload comparison.


- [Idempotency: How Not To Charge A Client Twice](/blog/idempotency-how-not-to-charge-a-client-twice/)
- [Unique Constraints Are Business Logic With Teeth](/blog/database-unique-constraints/)
