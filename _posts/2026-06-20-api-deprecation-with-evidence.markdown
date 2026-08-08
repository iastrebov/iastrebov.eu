---
layout: post
title: "API Deprecation: A Warning Header Is Not A Migration Plan"
date: 2026-06-20 09:40:00 +0100
categories: software engineering
tags: [api-design, deprecation, compatibility, observability]
excerpt_separator: <!--more-->
greeting: "remove only after clients moved"
description: "Deprecate APIs with ownership, usage evidence, replacement guidance, client communication, compatibility tests, and an enforced sunset process."
image:
  url: assets/images/blog/2026-06-20-api-deprecation-with-evidence-cover.png
  alt: "Live API traffic moving from an old bridge to a documented replacement before demolition"
---
Marking an endpoint deprecated in OpenAPI changes documentation. It does not update a mobile app, partner integration, forgotten batch job, or service nobody owns.

Removal needs evidence.

<!--more-->

## Identify Real Consumers

Instrument the deprecated route by authenticated client identity and operation. Sampling generic access logs is weak when one monthly payroll job matters more than a million test calls.

Create an owner list. Unknown consumers are work item, not permission to delete.

## Publish A Concrete Replacement

Document field mappings, semantic differences, authentication changes, pagination behavior, and examples. Give a date, support channel, and test environment.

If the new API cannot express an old use case, the consumer is not “resistant to migration.” Your replacement is incomplete.

## Enforce Stages

Move from announcement to warnings, direct contact, controlled test failures, and final shutdown. Keep rollback possible during the first enforcement window.

Compatibility tests should protect the old contract until the declared end. Quietly breaking it while telling clients to migrate is still breaking it.

The deletion commit is last five percent. Most deprecation work is discovering humans, traffic, and semantics hidden behind the endpoint.


- [Your API Is A Mess: 5 Rules For Backward Compatibility](/blog/your-api-is-a-mess-5-rules-for-backward-compatibility/)
- [Event Schema Evolution: Old Messages Outlive Your Deployment](/blog/event-schema-evolution/)
