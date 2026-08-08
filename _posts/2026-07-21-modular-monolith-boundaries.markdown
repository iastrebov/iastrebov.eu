---
layout: post
title: "A Modular Monolith Needs Enforced Boundaries"
date: 2026-07-21 09:00:00 +0100
categories: software engineering
tags: [architecture, modularity, java]
excerpt_separator: <!--more-->
greeting: hello
description: "A modular monolith keeps deployment simple while isolating business capabilities, but package names alone will not prevent architectural erosion."
image:
  url: assets/images/blog/2026-07-21-modular-monolith-boundaries-cover.png
  alt: Interlocking application modules inside one outer boundary with guarded connection points
---

A modular monolith is one deployable application with internal boundaries that matter. It avoids network calls and distributed operations between closely related capabilities, while preserving enough separation for teams to reason about change. The hard part is making those boundaries stronger than a diagram.

<!--more-->

Organize modules around business capabilities, not technical layers. An `orders` module should own its domain rules, persistence implementation, and public interface. A global `controllers`, `services`, and `repositories` structure spreads every feature across the entire codebase and makes dependency direction difficult to see.

Expose a deliberately small API from each module. Other modules should not reach into its tables or instantiate internal classes. For queries that cross boundaries, return purpose-built projections or publish internal events when eventual consistency is acceptable. Shared code should be genuinely generic; a large `common` module is often coupling with a polite name.

Then enforce the rules. Java package visibility can hide some internals. Separate build modules can make forbidden dependencies fail at compile time. Architecture tests can assert allowed package relationships. Database ownership can be checked through schemas, migration directories, and review rules even when one physical database serves the application.

Transactions are one advantage of a monolith, but avoid using a single transaction to justify arbitrary coupling. A business operation may coordinate modules through a narrow application service while each module retains its own invariants.

The architecture should also acknowledge change. Record why a boundary exists, what it owns, and what communication is allowed. Short [architecture decision records](/blog/architecture-decision-records/) keep those constraints connected to their rationale.

A modular monolith is not a promise to become microservices. It is a way to keep local calls, simple deployment, and strong consistency without accepting a codebase where every component can depend on everything else.
