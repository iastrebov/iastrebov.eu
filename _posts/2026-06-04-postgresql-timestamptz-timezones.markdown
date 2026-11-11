---
layout: post
title: "PostgreSQL timestamptz: Store Instants, Name Business Zones"
date: 2026-06-04 10:00:00 +0100
categories: software engineering
tags: [postgresql, timezones, java, data-modeling]
excerpt_separator: <!--more-->
greeting: "time without a model becomes folklore"
description: "Model PostgreSQL and Java time correctly with timestamptz, Instant, business zones, DST boundaries, and explicit local-time requirements."
image:
  url: assets/images/blog/2026-06-04-postgresql-timestamptz-timezones-cover.png
  alt: "One universal timeline projected onto several business-zone clocks with a DST gap"
---
“Store everything in UTC” is useful, incomplete advice. You also need to know whether the business fact is an instant, a local wall time, or a recurring rule in a named zone.

<!--more-->

## An Instant Is One Point On Timeline

Creation time, payment authorization time, and event receipt time are instants. In Java, use `Instant`. In PostgreSQL, `timestamptz` stores an absolute moment and renders it using the session zone.

Do not be surprised when the displayed offset changes after `SET TIME ZONE`; the stored instant did not.

## Local Time Can Be The Requirement

“Shop opens at 09:00 Europe/Lisbon” is not one instant. It is a rule evaluated in a named zone, including future daylight-saving changes.

Store the local time and zone ID when that is business meaning. Convert to instants for a particular date using the time-zone database.

## DST Creates Missing And Repeated Times

Some local times never occur during a spring transition. Others occur twice in autumn. Tests using only midday in January prove nothing about these boundaries.

Avoid `LocalDateTime` for events that already happened unless a separate zone or offset is stored. Avoid server-default zones in application logic; they change across laptops, containers, and deployments.

Time is a domain type. Choose the type that matches the statement. Test zone transitions and date boundaries. Adding UTC as magic suffix does not fix the model.


- [The Works On My Machine Excuse Ends Here](/blog/works-on-my-machine-excuse-ends-here/)
- [How To Read Documentation Like A Senior Engineer](/blog/how-to-read-documentation-like-a-senior-engineer/)
