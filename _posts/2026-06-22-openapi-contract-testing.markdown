---
layout: post
title: "OpenAPI Contract Testing: Documentation Must Be Executable"
date: 2026-06-22 07:55:00 +0100
categories: software engineering
tags: [openapi, api-design, testing, contracts]
excerpt_separator: <!--more-->
greeting: "a stale schema is worse than no schema"
description: "Turn OpenAPI into an executable contract with schema validation, compatibility checks, stable operation IDs, and representative response tests."
image:
  url: assets/images/blog/2026-06-22-openapi-contract-testing-cover.png
  alt: "An API schema blueprint continuously compared with real request and response traffic"
---
An OpenAPI file that says `amount` is a number while production returns a string is not documentation. It is a confident lie consumed by code generators.

<!--more-->

## Pick A Source Of Truth

Design-first and code-first can both work. The failure is allowing annotations, YAML, generated clients, and real responses to evolve independently.

Run schema validation against representative integration-test responses. Validate error responses too; happy-path drift is not the only contract break.

## Check Compatibility In CI

Compare the proposed specification with the released version. Removed operations, required new fields, narrowed enums, changed formats, and response-code changes deserve explicit review.

The [OpenAPI Specification](https://spec.openapis.org/oas/) treats `operationId` as a unique operation identifier. Keep it stable when generated clients use it for method names.

## Examples Need To Survive

Turn documented examples into test fixtures or generate fixtures from validated schemas. A copied example containing an old enum trains clients to fail.

OpenAPI cannot express every semantic rule. Add prose and executable domain tests for idempotency, ordering, and cross-field constraints. A schema is one contract layer, not whole system.


- [Your API Is A Mess: 5 Rules For Backward Compatibility](/blog/your-api-is-a-mess-5-rules-for-backward-compatibility/)
- [No Tests, No Merge: The Evidence A Pull Request Owes You](/blog/no-tests-no-merge-why-i-reject-half-of-prs/)
