---
layout: post
title: "Topological Sort Turns Dependencies Into an Execution Plan"
date: 2026-08-05 14:00:00 +0100
categories: software engineering
tags: [algorithms, graphs, dependencies]
excerpt_separator: <!--more-->
greeting: hello
description: "Topological sorting orders dependency work and detects cycles, making it useful for build steps, migrations, workflows, and configuration graphs."
image:
  url: assets/images/blog/2026-08-05-topological-sort-cover.png
  alt: A directed dependency graph resolving into ordered executable stages
---

Many execution problems are dependency problems in disguise. A migration requires a table, a build target requires generated sources, and a workflow step requires two earlier results. If the relationships form a directed acyclic graph, a topological sort produces an order that respects them.

<!--more-->

Kahn's algorithm makes the operational meaning clear. Count each node's incoming dependencies, place nodes with a zero count in a queue, then repeatedly emit one and decrement its dependents.

```java
Deque<Node> ready = new ArrayDeque<>();
indegree.forEach((node, count) -> {
    if (count == 0) ready.addLast(node);
});

while (!ready.isEmpty()) {
    Node done = ready.removeFirst();
    order.add(done);
    for (Node next : outgoing.getOrDefault(done, List.of())) {
        if (indegree.compute(next, (k, v) -> v - 1) == 0) {
            ready.addLast(next);
        }
    }
}
```

If the output contains fewer nodes than the graph, a cycle exists. That is not a sorting inconvenience; it means the requested dependency plan is impossible. Report the remaining nodes and, ideally, reconstruct a cycle so the user can repair the configuration.

The order is not necessarily unique. Several nodes may be ready at once. Use a priority queue when deterministic lexical order matters, or schedule all ready nodes in parallel when resources and failure semantics allow it. The graph defines precedence, not mandatory serialization.

Validate graph construction carefully. Missing nodes, duplicate edges, or an edge pointed in the wrong direction can create a plausible but incorrect plan. Name the edge consistently—“A depends on B” versus “B must precede A”—and test a small asymmetric example.

For very large graphs, both time and storage are linear in nodes plus edges. That efficiency makes topological sorting practical far beyond textbook tasks. Its real value is the combination of a valid execution order and an explicit proof when no such order can exist.
