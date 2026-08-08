---
layout: post
title: "Spring @Transactional Self-Invocation: The Proxy You Walked Around"
date: 2026-05-16 10:35:00 +0100
categories: software engineering
tags: [spring, transactions, java, debugging]
excerpt_separator: <!--more-->
greeting: "annotations work through objects"
description: "Understand why Spring transactional self-invocation bypasses proxy advice, how to prove it in a test, and which redesigns keep boundaries visible."
image:
  url: assets/images/blog/2026-05-16-spring-transaction-self-invocation-cover.png
  alt: "A method call taking a shortcut around a guarded transaction proxy gate"
---
The method has `@Transactional`. The insert commits separately anyway. This is not Spring randomly ignoring annotation; your call never reached the object that interprets it.

<!--more-->

## Follow The Call

In the common proxy-based model, another bean holds a proxy around your service. The proxy opens a transaction, invokes the target, then commits or rolls back.

~~~java
@Service
class SettlementService {
    void settle(Batch batch) {
        saveBatch(batch); // direct call on this
    }

    @Transactional
    public void saveBatch(Batch batch) {
        repository.save(batch);
    }
}
~~~

`settle` calls `this.saveBatch` in effect. No proxy boundary is crossed, so the transactional interceptor does not run.

Private methods have same practical problem in this model. Making the method public only to satisfy the proxy is a clue that ownership is wrong.

## Put The Boundary Where The Use Case Starts

Often the correct repair is simpler:

~~~java
@Transactional
public void settle(Batch batch) {
    validate(batch);
    repository.save(batch);
}
~~~

One use case, one transaction. Helper methods do not need annotations.

If the inner operation genuinely needs a separate boundary, move it to a separate bean with a name that explains why. `REQUIRES_NEW` is not a patch for self-invocation; it changes atomicity and must be justified as business behavior.

## Prove It With State, Not Logs

Write an integration test that triggers failure after the write and asserts what remains in database. A unit test calling the class directly cannot prove proxy behavior because it contains no proxy.

Also remember that rollback normally follows unchecked exceptions. Catching the failure inside the transactional method or converting it into a success result can make commit perfectly legal.

When a Spring annotation seems decorative, draw the runtime object graph. Framework magic is usually a normal object boundary hidden behind convenient syntax.


- [Why I Do Not Hire Framework Developers](/blog/why-i-dont-hire-framework-developers/)
- [Database Locks: The Silent Killer Of High-Load Systems](/blog/database-locks-silent-killer-high-load-systems/)
