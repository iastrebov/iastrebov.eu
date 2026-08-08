---
layout: post
title: "Keyset Pagination: Stop Making PostgreSQL Count Past Old Rows"
date: 2026-05-30 19:10:00 +0100
categories: software engineering
tags: [postgresql, pagination, api-design, performance]
excerpt_separator: <!--more-->
greeting: "continue from a value, not a page number"
description: "Replace deep OFFSET pagination with stable keyset cursors, composite ordering, and API contracts that survive concurrent inserts."
image:
  url: assets/images/blog/2026-05-30-keyset-pagination-cover.png
  alt: "A cursor continuing directly from one sorted database row while offset pages pile up behind"
---
`OFFSET 500000 LIMIT 50` asks the database to find and discard half a million rows before returning fifty. The page is small; the work is not.

<!--more-->

## Continue After The Last Key

For newest-first results with a unique tie-breaker:

~~~sql
select id, created_at, amount
from payments
where (created_at, id) < ($1, $2)
order by created_at desc, id desc
limit 50;
~~~

The cursor contains the last `created_at` and `id` from the previous response. A matching index supports the traversal.

~~~sql
create index payments_feed_order
on payments (created_at desc, id desc);
~~~

The unique `id` tie-breaker matters. Timestamps alone can repeat, producing missing or duplicated rows between pages.

## Cursor Is An API Contract

Encode cursor fields as an opaque token so clients do not depend on storage representation. Validate it, version it if the ordering contract may evolve, and reject a cursor used with incompatible filters.

Concurrent inserts before the cursor do not shift later pages as they do with offsets. Updates to ordering fields can still move records; immutable ordering keys make feeds more stable.

## Page Numbers May Be The Wrong Promise

Keyset pagination cannot jump cheaply to arbitrary page 7,842. Most user flows do not need that. They need “next,” “previous,” or infinite scroll.

For small admin tables, offset is perfectly acceptable. Change when depth and latency justify it, not because cursor pagination sounds senior.


- [PostgreSQL Index Column Order: The Left Edge Decides](/blog/postgresql-index-column-order/)
- [Your API Is A Mess: 5 Rules For Backward Compatibility](/blog/your-api-is-a-mess-5-rules-for-backward-compatibility/)
