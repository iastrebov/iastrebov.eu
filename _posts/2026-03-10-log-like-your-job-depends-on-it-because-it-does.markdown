---
layout: post
title: "Log Like Your Job Depends On It Because It Does"
date: 2026-03-10 12:04:00 +0000
categories: software engineering
tags: [observability, logging, java, microservices]
excerpt_separator: <!--more-->
greeting: "leave breadcrumbs"
description: "A practical observability guide to structured JSON logs, correlation IDs, MDC, log levels, and why println debugging is not enough."
image:
  url: assets/images/blog/2026-03-10-log-like-your-job-depends-on-it-because-it-does-cover.png
  alt: "Dark cyberpunk room with neon breadcrumb trail leading to a hidden software bug"
---
If your production debugging strategy is <code>System.out.println</code>, I hope your users are patient and your manager is forgiving.

Logs are not diary. Logs are evidence trail.

<!--more-->

## Structured Logs

String logs are hard to query.

Bad:

~~~java
log.info("User " + userId + " paid " + amount);
~~~

Better with structured fields, depending on logging stack:

~~~java
log.info("payment_authorized accountId={} amount={} currency={}",
    accountId, amount, currency);
~~~

Best when emitted as JSON with fields your platform indexes.

~~~json
{
  "event": "payment_authorized",
  "accountId": "acc-123",
  "amount": "10.00",
  "currency": "EUR",
  "correlationId": "req-abc"
}
~~~

## Correlation ID

One user request crosses API, ledger, risk, notification. Without correlation id, you search logs like archaeologist.

Use MDC in Java.

~~~java
class CorrelationFilter extends OncePerRequestFilter {
    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain chain) throws IOException, ServletException {
        String correlationId = Optional.ofNullable(request.getHeader("X-Correlation-Id"))
            .orElse(UUID.randomUUID().toString());
        MDC.put("correlationId", correlationId);
        try {
            response.setHeader("X-Correlation-Id", correlationId);
            chain.doFilter(request, response);
        } finally {
            MDC.clear();
        }
    }
}
~~~

Cleanup matters. Thread pools reuse threads.

## Log Levels

ERROR means action needed. WARN means suspicious but handled. INFO means business-important state transition. DEBUG is for development detail.

If everything is ERROR, nothing is ERROR.

## Do Not Leak Secrets

Never log card numbers, passwords, tokens, full personal data. Mask aggressively. Compliance people are not amused by your convenient debug line.

## Final Rule

When incident happens, logs should answer: who, what, when, where, correlation id, state transition, and failure reason.

Log like tired engineer at 3 AM depends on it. Because eventually it is you.

## Related reading

- [The Works On My Machine Excuse Ends Here](/blog/works-on-my-machine-excuse-ends-here/)
- [The $1 Million Bug: A Junior's Nightmare](/blog/one-million-dollar-bug-juniors-nightmare/)
- [How To Survive Your First On-Call Shift](/blog/how-to-survive-your-first-on-call-shift/)
