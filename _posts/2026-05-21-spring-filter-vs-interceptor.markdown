---
layout: post
title: "Spring Filter Or Interceptor? Choose The Boundary You Need"
date: 2026-05-21 15:55:00 +0100
categories: software engineering
tags: [spring, http, observability, security]
excerpt_separator: <!--more-->
greeting: "similar hooks, different contracts"
description: "Choose between servlet filters, Spring MVC interceptors, controller advice, and method aspects by the exact request boundary involved."
image:
  url: assets/images/blog/2026-05-21-spring-filter-vs-interceptor-cover.png
  alt: "An HTTP request passing through servlet, MVC, controller, and method boundary gates"
---
Filters and interceptors both run “around requests,” which is true in the same way that a building door and an office door are both doors. Placement changes what they can see and protect.

<!--more-->

## Filter: Servlet Boundary

A filter runs in the servlet chain before Spring MVC selects a controller. Use filters for correlation IDs, raw request wrapping, and security integrated with the servlet chain. They can also add headers when no controller matches.

~~~java
class CorrelationFilter extends OncePerRequestFilter {
    protected void doFilterInternal(HttpServletRequest request,
            HttpServletResponse response, FilterChain chain) throws IOException, ServletException {
        String id = correlationId(request);
        MDC.put("correlationId", id);
        try {
            response.setHeader("X-Correlation-Id", id);
            chain.doFilter(request, response);
        } finally {
            MDC.remove("correlationId");
        }
    }
}
~~~

Async dispatch and error dispatch need deliberate handling. “Once” has framework semantics, not magic global uniqueness.

## Interceptor: MVC Boundary

An MVC interceptor runs after handler mapping, so it can inspect the chosen handler and annotations. This fits locale decisions or request timing tied to route information.

Use Spring Security for authorization, with protection in the servlet filter chain or at the service method boundary. [Spring cautions against treating MVC interceptors as a security layer](https://docs.spring.io/spring-framework/reference/web/webmvc/mvc-config/interceptors.html) because path matching can differ.

It is not ideal for changing raw request bodies, and it will not cover traffic handled outside MVC.

## Advice And Aspects Are Other Tools

Use controller advice for response and exception shaping. Use method security or an aspect when the rule belongs to a service operation rather than HTTP transport.

Do not implement the same authentication check in all four places. Pick the earliest boundary with enough context, then test bypass paths such as errors, static resources, async dispatch, and non-controller entry points.

The correct hook is the one whose contract matches the invariant. Convenience is secondary.


- [Log Like Your Job Depends On It Because It Does](/blog/log-like-your-job-depends-on-it-because-it-does/)
- [The Works On My Machine Excuse Ends Here](/blog/works-on-my-machine-excuse-ends-here/)
