---
layout: post
title: "Stop Using ORMs Like A Junior"
date: 2025-12-14 18:33:00 +0000
categories: software engineering
tags: [database, hibernate, jpa, java]
excerpt_separator: <!--more-->
greeting: "hibernate is not brain"
description: "A blunt guide to ORM misuse: N+1 queries, lazy-loading traps, memory blowups, and why Java developers still need SQL."
image:
  url: assets/images/blog/2025-12-14-stop-using-orms-like-a-junior-cover.png
  alt: "Bloated ORM machine crushing a sleek server rack under heavy gears"
---
ORM is useful tool. Used like a junior, it becomes production tax collector.

Hibernate does not remove SQL. It hides SQL until your endpoint creates 900 queries and memory graph looks like crime scene.

<!--more-->

## The N+1 Trap

Bad code looks clean.

~~~java
List<Customer> customers = customerRepository.findActiveCustomers();
for (Customer customer : customers) {
    for (Order order : customer.getOrders()) {
        total = total.add(order.amount());
    }
}
~~~

If <code>orders</code> is lazy, this can execute one query for customers and one query per customer. It passes in dev with five rows. It dies in production with fifty thousand.

Clean Java, disgusting SQL behavior.

## Use Fetch Plan Intentionally

~~~java
@Query("""
    select distinct c
    from Customer c
    join fetch c.orders o
    where c.status = :status
    """)
List<Customer> findActiveCustomersWithOrders(CustomerStatus status);
~~~

Now you choose data shape explicitly. Better yet, for reporting, avoid entities and fetch projection.

~~~java
@Query("""
    select new com.company.ReportRow(c.id, sum(o.amount))
    from Customer c join c.orders o
    where c.status = :status
    group by c.id
    """)
List<ReportRow> totals(CustomerStatus status);
~~~

Do not load object universe just to calculate sum.

## Memory Is Also Query Problem

ORM session tracks entities. Load huge graph and you pay memory, dirty checking, cache pressure, and GC.

For batch processing, stream rows, page carefully, clear persistence context, or use JDBC/native query.

## Lazy Loading In API Layer Is Bug

If controller serializes entity and accidentally touches lazy relation, you just moved database access into JSON serialization. This is ugly.

Return DTOs. Decide fields. Keep transaction boundaries visible.

## You Still Need SQL

You need know indexes, query plans, joins, locking, isolation, and cardinality. Otherwise ORM magic becomes religion.

When production is slow, database will not show stack trace saying "developer trusted annotation too much". It will just burn CPU.

## Good ORM Usage

Use entities for transactional domain changes. Use projections for reads. Use explicit fetches for relationships. Monitor query count in tests. Read generated SQL.

Add tests that fail on N+1 when possible.

## Final Rule

ORM should reduce boilerplate, not remove understanding.

If you cannot explain SQL your code generates, you are not using ORM. ORM is using you.

## Related reading

- [Your Roadmap Is Wrong: Stop Learning Syntax, Start Building](/blog/your-roadmap-is-wrong-stop-learning-syntax-start-building/)
- [Why I Do Not Hire Framework Developers](/blog/why-i-dont-hire-framework-developers/)
- [Database Locks: The Silent Killer Of High-Load Systems](/blog/database-locks-silent-killer-high-load-systems/)
