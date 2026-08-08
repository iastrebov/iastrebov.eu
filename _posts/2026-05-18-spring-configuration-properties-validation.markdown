---
layout: post
title: "Spring Configuration Validation: Crash Before The First Request"
date: 2026-05-18 17:05:00 +0100
categories: software engineering
tags: [spring-boot, configuration, java, reliability]
excerpt_separator: <!--more-->
greeting: "invalid config is invalid deployment"
description: "Validate Spring Boot configuration as typed data so missing endpoints, impossible durations, and unsafe limits fail during startup."
image:
  url: assets/images/blog/2026-05-18-spring-configuration-properties-validation-cover.png
  alt: "A deployment capsule stopped at a validation gate before reaching live traffic"
---
A service that starts with an empty provider URL is not healthy. It is waiting for a customer request to discover deployment is broken.

Configuration should fail during startup, with the bad property named clearly.

<!--more-->

## Bind A Domain, Not Loose Strings

~~~java
@ConfigurationProperties("ledger")
@Validated
public record LedgerProperties(
    @NotNull URI endpoint,
    @NotNull @DurationMin(milliseconds = 50) Duration timeout,
    @Min(1) @Max(20) int retries
) {}
~~~

Typed binding catches malformed URIs and durations before application logic sees them. Validation adds domain limits: zero retries may be valid for one client, twenty thousand is not.

Enable properties through configuration scanning or an explicit registration, then test the application context with invalid values.

## Defaults Need A Reason

A default timeout of thirty seconds can quietly violate a two-second request objective. A missing secret must not become an empty string. Default only when the service can operate safely without an explicit choice.

Document units in property names or use duration syntax such as `250ms`. Bare integers invite one team to think milliseconds and another to think seconds.

## Keep Secrets Out Of Diagnostics

Validation messages should name the key, not print credentials. Actuator configuration endpoints and startup logs also need sanitization. “Helpful” dumps are common way to publish tokens into log storage.

## Test The Wiring

A constructor unit test proves validation logic, but not property names or binding. Add a small context test that supplies representative configuration. It catches spelling errors and missing registration.

Config is an input API operated by humans and automation. Give it types, validation, compatibility, and useful errors like any other API.


- [The Works On My Machine Excuse Ends Here](/blog/works-on-my-machine-excuse-ends-here/)
- [Java Exception Design: Stop Turning Every Failure Into 500](/blog/java-exception-design/)
