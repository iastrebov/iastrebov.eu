---
layout: post
title: "HTTP PATCH Semantics: Partial Update Is Not A Partial PUT"
date: 2026-06-21 14:15:00 +0100
categories: software engineering
tags: [http, patch, api-design, concurrency]
excerpt_separator: <!--more-->
greeting: "the document format defines the operation"
description: "Design HTTP PATCH with an explicit patch media type, validation, conditional requests, atomic application, and predictable null semantics."
image:
  url: assets/images/blog/2026-06-21-http-patch-semantics-cover.png
  alt: "A precise patch instruction applied to one resource version under an ETag guard"
---
Sending a normal DTO with half its fields missing does not define PATCH. Does missing mean unchanged? Does `null` clear the value? Can an array element be updated? Your framework cannot guess product semantics.

<!--more-->

## Choose A Patch Document

[RFC 5789](https://www.rfc-editor.org/rfc/rfc5789.html) defines PATCH as applying a set of changes represented by a media type. JSON Patch and JSON Merge Patch make different promises. A domain-specific command can also be clearer for business actions.

Advertise supported formats with `Accept-Patch` where appropriate and reject unsupported types with `415`.

## Apply Atomically

Validate the whole patch and commit it as one operation. Half-applied changes leave a resource in a state no client requested.

PATCH is not inherently idempotent. “Set status to CLOSED” can be repeatable; “increment balance by 10” is not. Document the operation instead of trusting the method name.

## Guard The Base Version

Some patches only make sense against the representation the client read. Use a strong ETag with `If-Match`; the RFC explicitly recommends conditional requests for collision-sensitive patches.

If the resource changed, return 412 and let the client reload or merge. Silently applying instructions to a new base is data corruption wearing REST vocabulary.


- [ETag And If-Match: Make Lost Updates A 412, Not Silent Data Loss](/blog/http-etag-if-match/)
- [Validation Boundaries In Spring: DTO Checks Are Not Domain Rules](/blog/validation-boundaries-spring-api/)
