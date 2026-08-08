---
layout: post
title: "ETag And If-Match: Make Lost Updates A 412, Not Silent Data Loss"
date: 2026-06-16 18:10:00 +0100
categories: software engineering
tags: [http, etag, concurrency, api-design]
excerpt_separator: <!--more-->
greeting: "clients must prove what they edited"
description: "Use strong ETags and If-Match preconditions to reject stale API updates before one client silently overwrites another client's work."
image:
  url: assets/images/blog/2026-06-16-http-etag-if-match-cover.png
  alt: "Two clients editing one resource while an ETag version gate rejects the stale copy"
---
Two clients read version 7. Both edit. Client A saves version 8; client B saves its stale copy and erases A's change.

HTTP already has a protocol for this collision.

<!--more-->

## Return A Validator

~~~http
HTTP/1.1 200 OK
ETag: "account-42-v7"
Content-Type: application/json
~~~

The client sends that validator with its update:

~~~http
PUT /accounts/42 HTTP/1.1
If-Match: "account-42-v7"
~~~

If current representation no longer matches, the server rejects the method with `412 Precondition Failed` instead of overwriting. [RFC 9110 describes `If-Match`](https://www.rfc-editor.org/rfc/rfc9110.html#name-if-match) specifically as useful for preventing lost updates.

## Strong Means Representation Changed

`If-Match` uses strong comparison. Generate a validator that changes whenever the relevant representation changes. A database version is convenient, but do not leak a weak meaning under strong syntax.

Evaluate the precondition and perform the update atomically. Reading a version in Java and updating later without a guarded `WHERE version = ?` recreates the race.

## Missing Preconditions Need A Policy

For an API where blind replacement is unsafe, require `If-Match` and reject clients that omit it. Document how clients refresh and merge after 412.

ETags also support cache validation through `If-None-Match`, but concurrency and caching are different jobs. Same header family, different intent.


- [Transaction Isolation Levels: Name The Anomaly You Cannot Accept](/blog/transaction-isolation-levels/)
- [Your API Is A Mess: 5 Rules For Backward Compatibility](/blog/your-api-is-a-mess-5-rules-for-backward-compatibility/)
