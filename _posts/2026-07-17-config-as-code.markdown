---
layout: post
title: "Configuration as Code Still Needs Runtime Discipline"
date: 2026-07-17 09:00:00 +0100
categories: software engineering
tags: [configuration, devops, delivery]
excerpt_separator: <!--more-->
greeting: hello
description: "Versioned configuration improves review and reproducibility, but safe runtime configuration also needs validation, ownership, and rollback behavior."
image:
  url: assets/images/blog/2026-07-17-config-as-code-cover.png
  alt: Versioned configuration blocks passing through validation gates into a running service
---

Putting configuration in Git gives every change a diff, reviewer, and history. It does not automatically make the change safe. A valid YAML file can still set a timeout below network latency, point production at a test endpoint, or enable a feature before its data migration is ready.

<!--more-->

Treat configuration as a typed interface. Define allowed fields, units, ranges, and relationships between values. Validate it in CI and again when the application loads it. Reject unknown keys: a misspelled option that silently falls back to a default is harder to diagnose than a failed deployment.

Separate secrets from ordinary settings. Repository history is a poor secret store, even when the repository is private. Commit references to secret locations and access policies; retrieve the values through the deployment environment. The application should log which configuration revision it loaded, never the secret values themselves.

Decide whether a setting is read at startup or refreshed at runtime. Startup-only configuration is easier to reason about because a deployment identifies the effective state. Dynamic reload is valuable for urgent operational controls, but it introduces partial-update and compatibility problems. If a setting reloads, make the update atomic, retain the last known-good value, and expose the active revision in diagnostics.

Ownership matters too. Infrastructure settings, application behavior, and product entitlements have different reviewers and failure modes. One undifferentiated directory invites changes that nobody feels responsible for validating.

A useful configuration change answers four questions in its review: what behavior changes, where it applies, how the result will be observed, and how to revert it. That makes configuration a controlled deployment input rather than an informal escape hatch. If it controls a temporary rollout branch, apply the same cleanup rules used for [feature flags](/blog/feature-flag-debt/).
