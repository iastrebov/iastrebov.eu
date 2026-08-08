---
layout: post
title: "Webhook Signature Verification: Authenticate The Bytes Before JSON"
date: 2026-06-17 07:20:00 +0100
categories: software engineering
tags: [webhooks, security, hmac, api]
excerpt_separator: <!--more-->
greeting: "the parsed object is already too late"
description: "Verify webhook HMAC signatures over raw request bytes, compare safely, rotate secrets, reject replays, and deduplicate delivery IDs."
image:
  url: assets/images/blog/2026-06-17-webhook-signature-verification-cover.png
  alt: "A sealed webhook payload passing HMAC verification before reaching a JSON parser"
---
If you parse and reserialize JSON before checking its signature, you may verify different bytes from those the sender signed. Whitespace, key order, and encoding are enough to break the comparison.

Authenticate raw body first.

<!--more-->

## Compute The Expected MAC

Provider contracts differ. GitHub, for example, documents an HMAC-SHA256 signature in `X-Hub-Signature-256` over the payload contents. Its [validation guide](https://docs.github.com/en/webhooks/using-webhooks/validating-webhook-deliveries) also recommends a timing-safe comparison.

~~~java
Mac mac = Mac.getInstance("HmacSHA256");
mac.init(new SecretKeySpec(secret, "HmacSHA256"));
byte[] expected = mac.doFinal(rawBody);

if (!MessageDigest.isEqual(expected, suppliedDigest)) {
    throw new InvalidWebhookSignature();
}
~~~

Parse algorithm prefixes and hex encoding exactly as provider specifies. Never log the secret or full signature on failure.

## Authentic Does Not Mean New

A captured valid request can be replayed. Where provider sends a timestamp, enforce a narrow age window and include that timestamp in the signed material as specified. Store a delivery ID under a unique constraint so duplicate deliveries become no-ops.

## Rotate Without A Blind Window

During rotation, accept the current and previous secret for a short controlled window, then remove the old one. Metrics should identify which key version verified without revealing key data.

Read body once, verify, parse, claim delivery identity, then perform idempotent work. Every step has a different security or reliability purpose.


- [At-Least-Once Delivery Means Duplicates: Design The Consumer First](/blog/at-least-once-delivery/)
- [Idempotency: How Not To Charge A Client Twice](/blog/idempotency-how-not-to-charge-a-client-twice/)
