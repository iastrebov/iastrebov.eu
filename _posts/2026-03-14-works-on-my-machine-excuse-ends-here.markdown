---
layout: post
title: "The Works On My Machine Excuse Ends Here"
date: 2026-03-14 10:28:00 +0000
categories: software engineering
tags: [docker, spring-boot, devops, backend]
excerpt_separator: <!--more-->
greeting: "ship the environment too"
description: "A strict mentor guide to Docker, environment parity, and why senior backend engineers own code from laptop to production server."
image:
  url: assets/images/blog/2026-03-14-works-on-my-machine-excuse-ends-here-cover.png
  alt: "Frustrated developer near a burning laptop while an organized server rack stays calm"
---
"Works on my machine" is not explanation. It is confession.

It means your delivery unit is incomplete. You shipped code but not environment. You tested behavior but not runtime assumptions. Then you blame ops when production refuses your fantasy.

<!--more-->

## Environment Is Part Of Software

Backend code does not run in your IDE. It runs inside OS image, JVM version, timezone, CPU limits, memory limits, network policy, secrets provider, database version, and deployment pipeline.

If your app depends on these things, your engineering must describe these things.

## Containerize The Boring Part

A basic Spring Boot Dockerfile is not magic. It is minimum hygiene.

~~~dockerfile
FROM eclipse-temurin:25-jre-alpine

WORKDIR /app

RUN addgroup -S app && adduser -S app -G app
USER app

COPY target/payment-service.jar app.jar

ENV JAVA_OPTS="-XX:MaxRAMPercentage=75"
EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
~~~

This does not solve architecture. It solves one stupid class of excuses: wrong JVM, missing file, different path, random local config.

## Your App Must Fail Loudly

Production should not discover missing environment variables after first customer request.

~~~java
@ConfigurationProperties(prefix = "ledger")
record LedgerProperties(URI endpoint, Duration timeout) {
    LedgerProperties {
        Objects.requireNonNull(endpoint, "ledger.endpoint");
        if (timeout == null || timeout.isNegative() || timeout.isZero()) {
            throw new IllegalArgumentException("ledger.timeout must be positive");
        }
    }
}
~~~

Fail at startup. Not after money is half-processed.

## Parity Beats Hero Debugging

Use same JVM major version locally and in CI. Run integration tests against containerized dependencies. Keep database migrations deterministic. Store configuration as versioned templates, not tribal memory.

A senior engineer does not say "but ops changed something" and walk away. A senior engineer asks: why was our contract with runtime not explicit?

## Containers Are Not Deployment Strategy

Docker is packaging. Kubernetes is scheduling. Neither saves bad app.

If your service logs nothing useful, ignores SIGTERM, stores local state in container filesystem, and needs manual click to initialize schema, container only makes failure portable.

## Production Ownership

You own code until it serves real traffic safely. That includes startup, shutdown, metrics, health checks, config validation, migrations, and rollback behavior.

The job is not to make app pass on laptop. The job is to make app boring in production.

## Simple Checklist

Pin runtime version. Build immutable image. Run tests in CI. Validate config. Expose health endpoint. Log request correlation id. Document required ports and dependencies. Practice rollback.

Now when something breaks, at least you debug real problem, not snowflake laptop fairy tale.

## Related reading

- [10 Years In Big Tech: The Ugly Truth About Fintech](/blog/10-years-in-big-tech-ugly-truth-about-fintech/)
- [Burnout Is For Those Who Cannot Say No](/blog/burnout-is-for-those-who-cant-say-no/)
- [My Developer Setup 2026: Tools That Actually Matter](/blog/my-developer-setup-2026-tools-that-actually-matter/)
