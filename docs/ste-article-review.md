# Article review with the STE-based writing skill

Reviewed on 2026-11-11 against `main` at `d00da4229286442342d8ff6359546223b3a612a3`.

All 141 articles in `_posts/` were read with the updated `write-egor-tech-post` skill. This review proposes focused changes to 55 articles and retains 86. The active content is in `iastrebov.eu`; the separate `egor.tech` repository is a redirect site.

## Why changes are needed

The recurring clarity problems were long descriptive sentences, instructions combining several actions, and paragraphs with more than six sentences. The edits split those passages without replacing the author's opinions, direct tone, metaphors, or permitted occasional grammar mistakes.

Accuracy changes address concrete problems found during that read:

- The virtual-thread article needs a JDK 24 boundary for monitor-related pinning. Lock contention and carrier pinning are different problems.
- The Spring filter/interceptor article should not recommend MVC interceptors as the security boundary.
- The index-order article needs the PostgreSQL 18 skip-scan exception.
- The TDD refactor must preserve behavior and compile against the types already introduced. New validation policies are behavior changes.
- The saga dispatcher should not wrap a provider call in a database transaction. Its handlers still need durable local transitions and recovery.
- The concurrency example must propagate the checked interruption from `await`. A launch barrier alone does not force the read/write interleaving described in the text.
- The equality example needs a constructor to initialize its final field. Its missing `hashCode` remains the intentional defect being taught.
- The SLO example must distinguish a fraction of failed requests from minutes of downtime.
- The top-K example needs an explicit positive-K precondition and handling for zero or negative K.
- The gRPC client needs explicit local-plaintext and channel-lifecycle assumptions. Other edits remove unsupported precision or absolute claims about performance, interning, and test-file changes.

## Editorial boundaries

This is an ASD-STE100-based blog review with the skill's house-style exceptions, not a full STE compliance claim. Word-count heuristics were used to find candidates, followed by contextual review. Technical names, literal strings, quoted passages, and code require different treatment from ordinary prose. The official-source list in the Java 25 article is retained; its long link labels are technical document names.

Existing publication dates, titles, permalinks, YAML metadata, images, and block quotations remain intact. Four fenced Java examples change for correctness; the other examples are preserved. The article-by-article table records every changed article's reason and explicitly identifies retained articles. “Retained” means no material edit was justified in this pass, not that every historical claim has independent certification.

## Validation

- Jekyll build: passed with the repository's existing `iastrebov-eu-jekyll` Docker image.
- Corpus checks: 141 articles, 141 existing local covers, and 256 resolving internal blog links. Front matter is unchanged; excerpt markers, unique permalinks, fenced-code balance, absence of duplicate body H1s, and preserved block quotations were checked.
- Java 25: all four changed snippets compiled in a temporary harness with imports and minimal domain fixtures. Checks covered 483 TDD boundary combinations, CustomerId construction/equality, saga dispatch, concurrent success/conflict and interruption, plus the documented top-K boundary policy.
- Rendered checks: home, resume, blog, and contact pages are present. All 141 post pages have one H1 and the expected cover/alt text. The revised learning steps render as an ordered list. Titles are unique.
- The Java fixtures do not establish real database, provider, or Spring behavior. Existing historical snippets were not all compiled or integration-tested.
- Source and rendered-page checks are limited to the isolated checkout. Unrelated local layout changes in the original checkout are excluded from this proposal.

Build command, from the repository root:

```bash
docker run --rm -v "$PWD:/site" iastrebov-eu-jekyll bundle exec jekyll build
```

## Primary references for technical corrections

- [Oracle: JDK 24 changes, including synchronization without pinning](https://docs.oracle.com/en/java/javase/24/migrate/significant-changes-jdk-24.html)
- [Oracle: Java 25 virtual threads](https://docs.oracle.com/en/java/javase/25/core/virtual-threads.html)
- [Spring: MVC interceptor security limitations](https://docs.spring.io/spring-framework/reference/web/webmvc/mvc-config/interceptors.html)
- [PostgreSQL 18: multicolumn indexes and skip scans](https://www.postgresql.org/docs/18/indexes-multicolumn.html)
- [gRPC: authentication and transport credentials](https://grpc.io/docs/guides/auth/)
- [Google SRE: service-level indicators and objectives](https://sre.google/sre-book/service-level-objectives/)

## Article-by-article decisions

| Article | Decision | Reason for change |
| --- | --- | --- |
| [Java 25 Is Here: Why Your Java 8 Code Is an Embarrassment](../_posts/2025-11-18-java-25-is-here-why-your-java-8-code-is-an-embarrassment.markdown) | Changed | Split a long catalogue of Java habits into two descriptive sentences. Give each migration action its own instruction. Keep the migration paragraph within six sentences after separating its instructions. |
| [Stop Asking For Mentors, Start Reading Code](../_posts/2025-11-24-stop-asking-for-mentors-start-reading-code.markdown) | Retained | Retain current wording. |
| [Your Roadmap Is Wrong: Stop Learning Syntax, Start Building](../_posts/2025-11-29-your-roadmap-is-wrong-stop-learning-syntax-start-building.markdown) | Retained | Retain current wording. |
| [A $100K-Class Missing-Index Post-Mortem](../_posts/2025-12-03-my-100k-mistake-a-post-mortem.markdown) | Retained | Retain current wording. |
| [Competitive Programming: Superpower Or Waste Of Time?](../_posts/2025-12-07-competitive-programming-superpower-or-waste-of-time.markdown) | Retained | Retain current wording. |
| [Stop Using ORMs Like A Junior](../_posts/2025-12-14-stop-using-orms-like-a-junior.markdown) | Retained | Retain current wording. |
| [Burnout Is For Those Who Cannot Say No](../_posts/2025-12-22-burnout-is-for-those-who-cant-say-no.markdown) | Retained | Retain current wording. |
| [Don't Be A Yes Man: How To Push Back On Product Managers](../_posts/2025-12-30-dont-be-a-yes-man-how-to-push-back-on-product-managers.markdown) | Retained | Retain current wording. |
| [Agile Is Dead, And You Killed It](../_posts/2026-01-03-agile-is-dead-and-you-killed-it.markdown) | Changed | Keep the seven-step closing paragraph within the six-sentence limit. |
| [Python Is For Scripts, Java Is For Business](../_posts/2026-01-09-python-is-for-scripts-java-is-for-business.markdown) | Changed | Split a seven-sentence paragraph while retaining the clipped mentor voice. Separate available Python modeling tools from the remaining runtime risks. |
| [The Anatomy Of A Perfect Code Review](../_posts/2026-01-16-anatomy-of-a-perfect-code-review.markdown) | Retained | Retain current wording. |
| [REST Is Lazy. Use gRPC For Real Systems](../_posts/2026-01-22-rest-is-lazy-use-grpc-for-real-systems.markdown) | Changed | State the transport and lifecycle assumptions hidden by the plaintext client example. |
| [Microservices Are Not A Silver Bullet: You Probably Need A Monolith](../_posts/2026-01-27-microservices-are-not-a-silver-bullet.markdown) | Changed | Qualify the distributed-systems claim: splitting services does not turn every transaction into a saga. |
| [Your API Is A Mess: 5 Rules For Backward Compatibility](../_posts/2026-01-31-your-api-is-a-mess-5-rules-for-backward-compatibility.markdown) | Retained | Retain current wording. |
| [String Theory: Optimizing Memory In High-Load Systems](../_posts/2026-02-03-string-theory-optimizing-memory-high-load-systems.markdown) | Changed | Replace an unconditional memory-leak claim with the actual capacity concern. |
| [Why You Failed The System Design Interview](../_posts/2026-02-08-why-you-failed-the-system-design-interview.markdown) | Changed | Group seven fragments into three focused operational questions. |
| [The Truth About LeetCode: It's Just An IQ Test](../_posts/2026-02-11-truth-about-leetcode-its-just-an-iq-test.markdown) | Retained | Retain current wording. |
| [Seniority Is Not About Years Of Experience](../_posts/2026-02-18-seniority-is-not-about-years-of-experience.markdown) | Retained | Retain current wording. |
| [Java Records: You're Still Writing Boilerplate?](../_posts/2026-02-21-java-records-youre-still-writing-boilerplate.markdown) | Retained | Retain current wording. |
| [Why I Do Not Hire Framework Developers](../_posts/2026-02-27-why-i-dont-hire-framework-developers.markdown) | Changed | Split a long conditional without smoothing away the intentional grammar. |
| [How To Survive Your First On-Call Shift](../_posts/2026-03-02-how-to-survive-your-first-on-call-shift.markdown) | Retained | Retain current wording. |
| [The $1 Million Bug: A Junior's Nightmare](../_posts/2026-03-06-one-million-dollar-bug-juniors-nightmare.markdown) | Changed | Separate missing-input checks from duplicate-processing risks and reduce paragraph length. |
| [Log Like Your Job Depends On It Because It Does](../_posts/2026-03-10-log-like-your-job-depends-on-it-because-it-does.markdown) | Retained | Retain current wording. |
| [The Works On My Machine Excuse Ends Here](../_posts/2026-03-14-works-on-my-machine-excuse-ends-here.markdown) | Changed | Split the overloaded failure list and make the container limitation explicit. Split the eight-sentence checklist into two readable groups. |
| [Clean Code Is Overrated When You Need Performance](../_posts/2026-03-18-clean-code-is-overrated-when-you-need-performance.markdown) | Changed | Remove an unsupported percentage while retaining the performance argument. |
| [Idempotency: How Not To Charge A Client Twice](../_posts/2026-03-22-idempotency-how-not-to-charge-a-client-twice.markdown) | Retained | Retain current wording. |
| [A Decade In Backend: The Uncomfortable Truth About Fintech](../_posts/2026-03-29-10-years-in-big-tech-ugly-truth-about-fintech.markdown) | Retained | Retain current wording. |
| [Refactoring Without Tests Is Just Guessing](../_posts/2026-04-04-refactoring-without-tests-is-just-guessing.markdown) | Retained | Retain current wording. |
| [Database Locks: The Silent Killer Of High-Load Systems](../_posts/2026-04-08-database-locks-silent-killer-high-load-systems.markdown) | Retained | Retain current wording. |
| [AI Coding Without Judgment Ships Bugs Faster](../_posts/2026-04-12-ai-wont-replace-you-but-i-will-if-you-use-it-like-a-junior.markdown) | Changed | Separate the example prompt sequence from six short questions and answers. Split a long list of AI uses while preserving the opinion and practical examples. |
| [Git Blame Is Not A Weapon, It's A Diagnostic Tool](../_posts/2026-04-15-git-blame-is-not-a-weapon-its-a-diagnostic-tool.markdown) | Changed | Separate prevention changes from operational improvements in an eight-sentence paragraph. |
| [Null Is Not An Option: Use Optional Or Fail](../_posts/2026-04-18-null-is-not-an-option-use-optional-or-fail.markdown) | Retained | Retain current wording. |
| [Stop Coding, Start Thinking: The True TDD Mindset](../_posts/2026-04-21-stop-coding-start-thinking-tdd-mindset.markdown) | Changed | Distinguish behavior-preserving refactoring from adding validation or currency rules. Make the refactor compile with the already-defined Decision record and BigDecimal field while preserving behavior. |
| [The Anatomy Of A Distributed Transaction](../_posts/2026-04-24-anatomy-of-a-distributed-transaction.markdown) | Changed | Remove the transaction around orchestration so callProvider is not shown inside a database transaction. Explain transaction ownership and the limits of the simplified saga dispatcher. |
| [How To Read Documentation Like A Senior Engineer](../_posts/2026-04-27-how-to-read-documentation-like-a-senior-engineer.markdown) | Retained | Retain current wording. |
| [Your 100% Test Coverage Is A Lie](../_posts/2026-04-29-your-100-percent-test-coverage-is-a-lie.markdown) | Retained | Retain current wording. |
| [A Developer Setup For 2026: Tools That Actually Matter](../_posts/2026-05-01-my-developer-setup-2026-tools-that-actually-matter.markdown) | Retained | Retain current wording. |
| [No Tests, No Merge: The Evidence A Pull Request Owes You](../_posts/2026-05-02-no-tests-no-merge-why-i-reject-half-of-prs.markdown) | Changed | Replace a long false dichotomy with the actual review criterion: evidence for changed behavior. |
| [Mockito Is Not A Testing Strategy](../_posts/2026-05-03-why-i-ban-mockito-in-my-teams.markdown) | Retained | Retain current wording. |
| [Master Structured Concurrency In Java 25](../_posts/2026-05-05-master-structured-concurrency-in-java-25.markdown) | Retained | Retain current wording. |
| [BigDecimal For Money: The Java Rules That Prevent Quiet Corruption](../_posts/2026-05-06-bigdecimal-money-java.markdown) | Changed | Separate the two constructor choices into conditional instructions under 20 words. |
| [Java equals And hashCode: One Broken Contract, Many Missing Objects](../_posts/2026-05-07-java-equals-hashcode-contract.markdown) | Changed | Initialize the final field so the deliberately broken hashCode example compiles and demonstrates the intended equality defect. |
| [Immutability In Java: Fewer States, Fewer Production Surprises](../_posts/2026-05-08-immutability-java-backend.markdown) | Changed | Give entity design, setter visibility, and validation separate instructions. |
| [Java Exception Design: Stop Turning Every Failure Into 500](../_posts/2026-05-09-java-exception-design.markdown) | Retained | Retain current wording. |
| [Java Generics Variance: PECS Without The Parrot Lesson](../_posts/2026-05-10-java-generics-variance.markdown) | Retained | Retain current wording. |
| [Java Stream Side Effects: Clean Syntax, Dirty Semantics](../_posts/2026-05-11-java-stream-side-effects.markdown) | Retained | Retain current wording. |
| [Virtual Threads Still Block: Find The Pin Before Production Does](../_posts/2026-05-12-virtual-threads-pinning.markdown) | Changed | Add the JDK 24 boundary: monitor-related pinning advice was outdated for the blog’s Java 25 context. Separate lock contention from carrier pinning so the unchanged example remains accurate. Make the lock-release sequence explicit and avoid implying stale state can be applied without coordination. Link the verified Java 25 guide without an unverified fragment identifier. |
| [Java GC Latency: Read The Allocation Story Before Tuning Flags](../_posts/2026-05-13-java-gc-latency-basics.markdown) | Changed | Separate memory-limit verification from native-memory budgeting. |
| [Java Flight Recorder: Profile Production Without Guessing](../_posts/2026-05-14-java-flight-recorder-production.markdown) | Retained | Retain current wording. |
| [CompletableFuture Error Handling: The Exception Is Still There](../_posts/2026-05-15-completablefuture-error-handling.markdown) | Changed | Replace a 31-word sentence with two distinct failure modes. |
| [Spring @Transactional Self-Invocation: The Proxy You Walked Around](../_posts/2026-05-16-spring-transaction-self-invocation.markdown) | Changed | Explain the proxy limitation and atomicity tradeoff separately. |
| [Database Connection Pool Sizing: More Connections Can Make You Slower](../_posts/2026-05-17-database-connection-pool-sizing.markdown) | Retained | Retain current wording. |
| [Spring Configuration Validation: Crash Before The First Request](../_posts/2026-05-18-spring-configuration-properties-validation.markdown) | Retained | Retain current wording. |
| [Validation Boundaries In Spring: DTO Checks Are Not Domain Rules](../_posts/2026-05-19-validation-boundaries-spring-api.markdown) | Changed | Replace an imperative-shaped warning with a direct explanation of validation bypasses. |
| [Spring ControllerAdvice: Stable Errors Without A Catch-All Mess](../_posts/2026-05-20-spring-controller-advice-errors.markdown) | Changed | Give one clear logging instruction and explain the duplicate-log failure. |
| [Spring Filter Or Interceptor? Choose The Boundary You Need](../_posts/2026-05-21-spring-filter-vs-interceptor.markdown) | Changed | Split the long filter-responsibility list into a direct instruction and one explanation. Remove a misleading security recommendation and cite Spring’s documented interceptor limitation. |
| [Spring Retry Can Duplicate Side Effects: Annotate With Suspicion](../_posts/2026-05-22-spring-retry-duplicate-side-effects.markdown) | Retained | Retain current wording. |
| [Transactional Outbox In Spring: Commit Data And Intent Together](../_posts/2026-05-23-transactional-outbox-spring.markdown) | Retained | Retain current wording. |
| [Hexagonal Architecture In Java: Ports Must Earn Their Names](../_posts/2026-05-24-hexagonal-architecture-java.markdown) | Retained | Retain current wording. |
| [Spring Scheduled Jobs: One Cron, Three Instances, Triple Work](../_posts/2026-05-25-spring-scheduled-job-overlap.markdown) | Retained | Retain current wording. |
| [PostgreSQL Index Column Order: The Left Edge Decides](../_posts/2026-05-26-postgresql-index-column-order.markdown) | Changed | Account for PostgreSQL 18 skip scans instead of presenting a planner heuristic as an absolute rule. |
| [EXPLAIN ANALYZE: Read The PostgreSQL Plan Without Guessing](../_posts/2026-05-27-postgresql-explain-analyze.markdown) | Retained | Retain current wording. |
| [PostgreSQL MVCC And Vacuum: Dead Rows Are Still Work](../_posts/2026-05-28-postgresql-mvcc-vacuum.markdown) | Changed | Break a 29-word diagnostic list into steps with named observations. |
| [Transaction Isolation Levels: Name The Anomaly You Cannot Accept](../_posts/2026-05-29-transaction-isolation-levels.markdown) | Retained | Retain current wording. |
| [Keyset Pagination: Stop Making PostgreSQL Count Past Old Rows](../_posts/2026-05-30-keyset-pagination.markdown) | Retained | Retain current wording. |
| [PostgreSQL JSONB: Flexible Schema, Permanent Query Bill](../_posts/2026-05-31-postgresql-jsonb-tradeoffs.markdown) | Retained | Retain current wording. |
| [Unique Constraints Are Business Logic With Teeth](../_posts/2026-06-01-database-unique-constraints.markdown) | Retained | Retain current wording. |
| [Zero-Downtime Database Migrations: Expand Before You Contract](../_posts/2026-06-02-zero-downtime-database-migrations.markdown) | Retained | Retain current wording. |
| [PostgreSQL UPSERT: One Statement Does Not Define Your Conflict Policy](../_posts/2026-06-03-postgresql-upsert-concurrency.markdown) | Retained | Retain current wording. |
| [PostgreSQL timestamptz: Store Instants, Name Business Zones](../_posts/2026-06-04-postgresql-timestamptz-timezones.markdown) | Changed | Separate time-model selection from boundary testing. |
| [Timeout Budgets: Your 200 ms Service Cannot Make Three 200 ms Calls](../_posts/2026-06-05-timeout-budget-distributed-systems.markdown) | Retained | Retain current wording. |
| [Retry Backoff And Jitter: Stop Recreating The Outage In Waves](../_posts/2026-06-06-retry-backoff-jitter.markdown) | Retained | Retain current wording. |
| [Circuit Breakers: A Failure Policy, Not A Resilience Sticker](../_posts/2026-06-07-circuit-breaker-failure-policy.markdown) | Retained | Retain current wording. |
| [At-Least-Once Delivery Means Duplicates: Design The Consumer First](../_posts/2026-06-08-at-least-once-delivery.markdown) | Changed | Split the long explanation of idempotent state transitions. |
| [Out-Of-Order Events: Timestamps Will Not Save Your State Machine](../_posts/2026-06-09-out-of-order-events.markdown) | Retained | Retain current wording. |
| [Event Schema Evolution: Old Messages Outlive Your Deployment](../_posts/2026-06-10-event-schema-evolution.markdown) | Retained | Retain current wording. |
| [Distributed Clocks: createdAt Is Not A Global Sequence Number](../_posts/2026-06-11-distributed-clocks-timestamps.markdown) | Retained | Retain current wording. |
| [Cache Invalidation: First Decide How Wrong A Read May Be](../_posts/2026-06-12-cache-invalidation-strategy.markdown) | Retained | Retain current wording. |
| [Backpressure: Fast Producers Need Permission To Continue](../_posts/2026-06-13-backpressure-overload-control.markdown) | Retained | Retain current wording. |
| [Distributed Leases Need Fencing Tokens, Not Hope](../_posts/2026-06-14-distributed-leases-fencing-tokens.markdown) | Retained | Retain current wording. |
| [HTTP Problem Details: Stop Inventing A New Error Shape Per Endpoint](../_posts/2026-06-15-http-problem-details.markdown) | Retained | Retain current wording. |
| [ETag And If-Match: Make Lost Updates A 412, Not Silent Data Loss](../_posts/2026-06-16-http-etag-if-match.markdown) | Retained | Retain current wording. |
| [Webhook Signature Verification: Authenticate The Bytes Before JSON](../_posts/2026-06-17-webhook-signature-verification.markdown) | Retained | Retain current wording. |
| [Secure File Uploads: Content-Type Is User Input Too](../_posts/2026-06-18-secure-file-upload-api.markdown) | Changed | Put the exceptional execution case in its own conditional instruction. |
| [API Rate Limiting: Count The Resource You Are Protecting](../_posts/2026-06-19-api-rate-limiting.markdown) | Retained | Retain current wording. |
| [API Deprecation: A Warning Header Is Not A Migration Plan](../_posts/2026-06-20-api-deprecation-with-evidence.markdown) | Retained | Retain current wording. |
| [HTTP PATCH Semantics: Partial Update Is Not A Partial PUT](../_posts/2026-06-21-http-patch-semantics.markdown) | Retained | Retain current wording. |
| [OpenAPI Contract Testing: Documentation Must Be Executable](../_posts/2026-06-22-openapi-contract-testing.markdown) | Retained | Retain current wording. |
| [API Idempotency Keys: The Same Key Must Mean The Same Request](../_posts/2026-06-23-api-idempotency-keys.markdown) | Retained | Retain current wording. |
| [HTTP 202 Accepted: Give Long Jobs A Resource, Not A Promise](../_posts/2026-06-24-http-202-async-api.markdown) | Retained | Retain current wording. |
| [The Test Pyramid Is A Cost Model, Not A Quota](../_posts/2026-06-25-test-pyramid-risk-model.markdown) | Retained | Retain current wording. |
| [Mutation Testing: Make Sure Your Assertions Can Kill A Bug](../_posts/2026-06-26-mutation-testing-java.markdown) | Retained | Retain current wording. |
| [Property-Based Testing: Stop Hand-Picking Polite Inputs](../_posts/2026-06-27-property-based-testing.markdown) | Retained | Retain current wording. |
| [Deterministic Time Tests: Stop Sleeping And Inject A Clock](../_posts/2026-06-28-deterministic-time-tests.markdown) | Retained | Retain current wording. |
| [Flaky Tests Are Production Bugs In Your Feedback System](../_posts/2026-06-29-flaky-tests-debugging.markdown) | Retained | Retain current wording. |
| [Consumer-Driven Contract Tests: Verify The Fields Clients Actually Need](../_posts/2026-06-30-consumer-driven-contract-tests.markdown) | Changed | Separate contract publication, build association, and deployment policy into distinct instructions. |
| [Fast Testcontainers: Reuse Infrastructure, Reset State](../_posts/2026-07-01-testcontainers-speed.markdown) | Retained | Retain current wording. |
| [Database Test Fixtures: Small Data, Real Constraints](../_posts/2026-07-02-database-test-fixtures.markdown) | Retained | Retain current wording. |
| [Approval Tests: Snapshot The Contract, Not The Noise](../_posts/2026-07-03-approval-tests.markdown) | Retained | Retain current wording. |
| [Java Concurrency Tests: Coordinate The Race, Do Not Pray For It](../_posts/2026-07-04-concurrency-tests-java.markdown) | Changed | Distinguish simultaneous worker starts from forcing a specific database race. Use Callable so the checked InterruptedException from await is valid and can propagate through Future.get. |
| [SLOs Turn Reliability From An Argument Into A Budget](../_posts/2026-07-05-slo-error-budget.markdown) | Changed | Distinguish request-based error budgets from time-based downtime instead of converting between them implicitly. |
| [An Alert Without An Action Is Just Expensive Noise](../_posts/2026-07-06-actionable-alerts.markdown) | Retained | Retain current wording. |
| [High-Cardinality Metrics Can Bankrupt Your Observability](../_posts/2026-07-07-metrics-cardinality.markdown) | Retained | Retain current wording. |
| [Trace Sampling: Keep The Weird Requests, Not Just One Percent](../_posts/2026-07-08-trace-sampling.markdown) | Retained | Retain current wording. |
| [Queue Depth Lies: Measure The Age Of Work](../_posts/2026-07-09-queue-lag-observability.markdown) | Retained | Retain current wording. |
| [Heap Dumps Are Evidence—and A Production Hazard](../_posts/2026-07-10-heap-dump-production-safety.markdown) | Retained | Retain current wording. |
| [Your Cache Is A Memory Leak With A Hit-Rate Dashboard](../_posts/2026-07-11-cache-memory-leak.markdown) | Retained | Retain current wording. |
| [Profile CPU Before Optimizing The Code You Suspect](../_posts/2026-07-12-cpu-profiling-production.markdown) | Retained | Retain current wording. |
| [A Load Test Is Only As Honest As Its Traffic Model](../_posts/2026-07-13-realistic-load-testing.markdown) | Retained | Retain current wording. |
| [Graceful Shutdown Is A Deadline, Not A Courtesy](../_posts/2026-07-14-graceful-shutdown.markdown) | Retained | Retain current wording. |
| [Feature Flags Need an Expiration Date](../_posts/2026-07-15-feature-flag-debt.markdown) | Retained | Retain current wording. |
| [Blue-Green and Canary Releases Solve Different Problems](../_posts/2026-07-16-blue-green-vs-canary.markdown) | Changed | Give rollout criteria and error-budget linkage separate instructions. |
| [Configuration as Code Still Needs Runtime Discipline](../_posts/2026-07-17-config-as-code.markdown) | Changed | Split a long list of syntactically valid but unsafe configuration changes. Separate the configuration validation instruction from its reason. Keep storing references and retrieving secret values as separate instructions. Shorten the configuration review checklist without losing any required answer. |
| [Fast CI Is a Feedback Design Problem](../_posts/2026-07-18-fast-ci-pipelines.markdown) | Changed | Separate full-suite scheduling from monitoring test-selection gaps. Split a long cause-and-consequence sentence. |
| [Build Smaller Docker Images for Security, Not Fashion](../_posts/2026-07-19-secure-docker-images.markdown) | Retained | Retain current wording. |
| [Kubernetes Probes Should Answer One Question Each](../_posts/2026-07-20-kubernetes-probes.markdown) | Retained | Retain current wording. |
| [A Modular Monolith Needs Enforced Boundaries](../_posts/2026-07-21-modular-monolith-boundaries.markdown) | Retained | Retain current wording. |
| [Architecture Decision Records Preserve the Why](../_posts/2026-07-22-architecture-decision-records.markdown) | Changed | Separate loss of decision context from its maintenance consequences. Separate the ADR writing instruction from its list of possible constraints. Split the overloaded rule for deciding when an ADR is needed. |
| [Build Versus Buy Is an Ownership Decision](../_posts/2026-07-23-build-vs-buy.markdown) | Retained | Retain current wording. |
| [Small Dependency Upgrades Beat Heroic Migrations](../_posts/2026-07-24-dependency-upgrades.markdown) | Changed | Separate vulnerability assessment from the boundary on deferring remediation. |
| [Code Ownership Without Knowledge Silos](../_posts/2026-07-25-code-ownership.markdown) | Retained | Retain current wording. |
| [Use Estimation Ranges to Expose Uncertainty](../_posts/2026-07-26-estimation-ranges.markdown) | Changed | Turn a long estimation instruction into three explicit assumptions to investigate. |
| [An Incident Commander Protects the Debugging Team](../_posts/2026-07-27-incident-commander.markdown) | Retained | Retain current wording. |
| [Code Review Can Teach Without Becoming a Lecture](../_posts/2026-07-28-mentoring-through-code-review.markdown) | Changed | Split the closing causal explanation and make knowledge sharing concrete. |
| [A Technical Debt Register Must Drive Decisions](../_posts/2026-07-29-technical-debt-register.markdown) | Retained | Retain current wording. |
| [Design Meetings Should Produce Decisions](../_posts/2026-07-30-decision-focused-meetings.markdown) | Retained | Retain current wording. |
| [Staff-Level Influence Starts With Decision Quality](../_posts/2026-07-31-staff-engineer-influence.markdown) | Retained | Retain current wording. |
| [Write Design Documents for the Hard Questions](../_posts/2026-08-01-design-docs.markdown) | Changed | Separate the positive and negative diagram instructions. |
| [Debugging Is Controlled Hypothesis Testing](../_posts/2026-08-02-systematic-debugging.markdown) | Changed | Replace vague symptom framing with the specific diagnostic information a reader should collect. |
| [Build an Engineering Learning Plan Around Output](../_posts/2026-08-03-engineering-learning-plan.markdown) | Changed | Give each learning action its own step while preserving the original sequence. Separate the tracking instruction from the limitation of activity metrics. |
| [Bloom Filters Trade Certainty for Fewer Lookups](../_posts/2026-08-04-bloom-filters.markdown) | Changed | Separate the filter-selection instruction from its false-positive constraint. |
| [Queues and Deques Encode Processing Order](../_posts/2026-08-04-queues-and-deques.markdown) | Changed | Give each data-structure choice its own instruction and make FIFO ordering explicit. |
| [Consistent Hashing Limits Remapping, Not Imbalance](../_posts/2026-08-05-consistent-hashing.markdown) | Changed | Separate replica placement from the remaining storage-system responsibilities. |
| [Topological Sort Turns Dependencies Into an Execution Plan](../_posts/2026-08-05-topological-sort.markdown) | Changed | Separate graph initialization from the repeated topological-sort operation. Give deterministic ordering and parallel scheduling separate conditional instructions. |
| [Binary Search Can Find a Feasible Boundary](../_posts/2026-08-06-binary-search-on-answer.markdown) | Changed | Separate the arithmetic requirement from the failure mechanism. Split the long conclusion into the mechanism and the condition for using it. |
| [Use a Bounded Heap for Streaming Top-K](../_posts/2026-08-06-top-k-with-heaps.markdown) | Changed | State the missing K boundary so readers do not call peek on an empty heap. |
| [Sliding Windows Remove Repeated Work](../_posts/2026-08-07-sliding-window.markdown) | Changed | Split the long introduction into a definition and examples. |
| [Union-Find Tracks Connectivity as Groups Merge](../_posts/2026-08-07-union-find.markdown) | Changed | Give the structure’s scope and its invariant separate sentences. |
| [Set Complexity Budgets Before Optimizing Code](../_posts/2026-08-08-complexity-budgets.markdown) | Changed | Shorten the instruction and clarify that the controls are alternatives for different operations. Keep the conditional resource-control instructions within the procedural sentence limit. |
| [A Trie Makes Prefix Search Explicit](../_posts/2026-08-08-trie-autocomplete.markdown) | Changed | Separate trie representation from prefix-traversal complexity. |
| [This AI-Written Blog Is Not AI Slop](../_posts/2026-08-09-ai-supervised-human-owned.markdown) | Changed | Split the long list of article origins while preserving the author’s account. Give each editorial acceptance condition a clear sentence. |
