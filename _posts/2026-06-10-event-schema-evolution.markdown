---
layout: post
title: "Event Schema Evolution: Old Messages Outlive Your Deployment"
date: 2026-06-10 16:25:00 +0100
categories: software engineering
tags: [events, schema, compatibility, distributed-systems]
excerpt_separator: <!--more-->
greeting: "the queue remembers old contracts"
description: "Evolve event schemas with additive fields, semantic compatibility, tolerant readers, versioned meaning, and replay tests against stored history."
image:
  url: assets/images/blog/2026-06-10-event-schema-evolution-cover.png
  alt: "Old and new event envelopes passing through one backward-compatible schema gate"
---
An HTTP response disappears after a client reads it. An event may sit in a queue, archive, retry topic, or audit store for months. Old payloads can return during replay long after producers changed.

<!--more-->

## Add Before You Remove

New optional fields are usually safer than renames. Consumers should tolerate unknown fields. Producers should not assume every consumer deployed together.

Changing meaning while keeping a field name is still breaking. If `amount` changes from major-unit string to minor-unit integer, add a new field or event version and migrate deliberately.

## Defaults Can Invent Facts

A missing `country` does not necessarily mean `US`. A default used for parsing becomes business data during replay. Distinguish unknown, absent, and actual default.

## Test Stored Samples

Keep representative historical payloads and run them against new consumers. Also test a new producer payload against the oldest supported consumer where tooling permits.

Schema registries can enforce structural rules. They cannot determine whether changing `CANCELLED` to mean “refund pending” preserves semantics.

Document ownership, compatibility window, deprecation evidence, and replay behavior. Event evolution is API evolution with a much longer memory.


- [Your API Is A Mess: 5 Rules For Backward Compatibility](/blog/your-api-is-a-mess-5-rules-for-backward-compatibility/)
- [Transactional Outbox In Spring: Commit Data And Intent Together](/blog/transactional-outbox-spring/)
