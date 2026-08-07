---
layout: post
title: "Your API Is A Mess: 5 Rules For Backward Compatibility"
date: 2026-01-31 08:41:00 +0000
categories: software engineering
tags: [api-design, backward-compatibility, json, architecture]
excerpt_separator: <!--more-->
greeting: "do not break clients"
description: "A strict API compatibility guide covering versioning, never removing fields, tolerant readers, additive changes, and JSON evolution."
image:
  url: assets/images/blog/2026-01-31-your-api-is-a-mess-5-rules-for-backward-compatibility-cover.png
  alt: "Futuristic bridge rebuilt while high-speed cars continue driving over it"
---
Breaking API clients because you renamed field is not innovation. It is vandalism with release notes.

Public API and internal shared API need backward compatibility discipline. Otherwise every deploy becomes coordination meeting.

<!--more-->

## Rule 1: Add, Do Not Remove

Bad evolution:

~~~json
{
  "id": "p1",
  "amount": "10.00"
}
~~~

Changed to:

~~~json
{
  "paymentId": "p1",
  "minorUnits": 1000
}
~~~

Old clients break. Good job, you shipped outage.

Safer evolution:

~~~json
{
  "id": "p1",
  "paymentId": "p1",
  "amount": "10.00",
  "minorUnits": 1000
}
~~~

Deprecate old fields. Remove only after contract window and evidence clients migrated.

## Rule 2: Tolerant Reader

Clients should ignore unknown fields.

~~~java
@JsonIgnoreProperties(ignoreUnknown = true)
record PaymentResponse(String id, BigDecimal amount) {}
~~~

This allows server to add fields without breaking old clients.

## Rule 3: Version Major Breaks

If you must break contract, make new version explicit: <code>/v2/payments</code> or media type versioning or separate gRPC package.

Do not sneak breaking change into same endpoint because it is convenient.

## Rule 4: Preserve Meaning

Changing field semantics is breaking even if name stays same.

If <code>amount</code> used to mean major units string and now means minor units integer, you broke API.

## Rule 5: Test Compatibility

Keep contract tests. Run consumer tests. Validate old payloads against new code and new payloads against old tolerant readers.

API compatibility is not document promise. It is executable check.

## Final Rule

API is not your private DTO. It is contract with other humans and systems.

Evolve it like bridge under traffic: slowly, visibly, and without dropping cars into river.

## Related reading

- [The Works On My Machine Excuse Ends Here](/blog/works-on-my-machine-excuse-ends-here/)
- [The Anatomy Of A Perfect Code Review](/blog/anatomy-of-a-perfect-code-review/)
