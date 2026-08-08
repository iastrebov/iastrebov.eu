---
layout: post
title: "Union-Find Tracks Connectivity as Groups Merge"
date: 2026-08-07 09:00:00 +0100
categories: software engineering
tags: [algorithms, graphs, data-structures]
excerpt_separator: <!--more-->
greeting: hello
description: "Union-find efficiently answers whether items belong to the same connected component while edges are added, using path compression and ranked merging."
image:
  url: assets/images/blog/2026-08-07-union-find-cover.png
  alt: Separate clusters merging through representative roots with compressed connection paths
---

If relationships only accumulate, repeatedly traversing a graph to ask whether two items are connected does unnecessary work. Union-find, also called disjoint-set union, maintains a partition of items into components as those components merge.

<!--more-->

Each item points toward a representative root. `find(x)` follows parent pointers to that root. `union(a, b)` finds both roots and connects them if they differ. Two items are connected when their roots match.

Two small optimizations make the structure extremely efficient. Path compression rewrites nodes visited during `find` to point closer to the root. Union by size or rank attaches the smaller tree below the larger one, preventing tall chains.

```java
int find(int x) {
    if (parent[x] != x) {
        parent[x] = find(parent[x]);
    }
    return parent[x];
}

void union(int a, int b) {
    int ra = find(a);
    int rb = find(b);
    if (ra == rb) return;
    if (size[ra] < size[rb]) { int t = ra; ra = rb; rb = t; }
    parent[rb] = ra;
    size[ra] += size[rb];
}
```

This supports cycle detection in undirected graphs, grouping equivalent identifiers, building minimum spanning trees, and tracking connected regions. Over a sequence of operations, the amortized cost is effectively constant for practical input sizes.

The limitation is as important as the speed: ordinary union-find does not handle deletions or answer path questions. Once two groups merge, it cannot cheaply split them again. Dynamic connectivity with edge removal needs a different or offline approach. It also tells you that two items connect, not which edges form a route between them.

Initialize every item as its own parent, and keep component metadata only at roots. Union-find is a narrow structure, but within that boundary it replaces repeated graph searches with a clear invariant: every member of a component resolves to the same representative.
