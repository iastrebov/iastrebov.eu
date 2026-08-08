---
layout: post
title: "Database Test Fixtures: Small Data, Real Constraints"
date: 2026-07-02 07:45:00 +0100
categories: software engineering
tags: [testing, database, fixtures, sql]
excerpt_separator: <!--more-->
greeting: "fixtures should explain the scenario"
description: "Build database test fixtures that expose constraints, query behavior, and edge cases without copying a production dump into every test."
image:
  url: assets/images/blog/2026-07-02-database-test-fixtures-cover.png
  alt: "A small labeled database fixture set exercising real constraints and query edges"
---
A 2 GB production dump makes tests slow, opaque, and full of data nobody understands. Three perfect rows can make a broken query look correct.

Fixtures need small intent and realistic constraints.

<!--more-->

## Name Rows By Their Job

Create the active account, expired account, duplicate business key, boundary timestamp, and unrelated tenant the test needs. Builders should choose safe defaults while forcing fields relevant to the scenario.

Run real migrations so constraints and indexes match production. A hand-created test schema drifts quietly.

## Add Shape Tests Separately

Correctness fixtures do not prove performance. Maintain a smaller set of volume or query-plan tests that create skew and cardinality intentionally.

Avoid assertions depending on auto-generated IDs or implicit row order. Query with explicit ordering and compare business fields.

Keep fixture creation near the test that explains it. A global seed script encourages accidental dependencies: removing an unrelated customer suddenly breaks an invoice scenario. Shared builders are useful for mechanics, but the test should still declare the rows its behavior requires.

The best fixture makes the failure readable: one extra row demonstrates the leak, one boundary value demonstrates the bug.

## Database Evidence

- [EXPLAIN ANALYZE: Read The PostgreSQL Plan Without Guessing](/blog/postgresql-explain-analyze/)
- [Refactoring Without Tests Is Just Guessing](/blog/refactoring-without-tests-is-just-guessing/)
