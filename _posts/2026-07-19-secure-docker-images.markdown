---
layout: post
title: "Build Smaller Docker Images for Security, Not Fashion"
date: 2026-07-19 09:00:00 +0100
categories: software engineering
tags: [docker, security, devops]
excerpt_separator: <!--more-->
greeting: hello
description: "A secure container image has a minimal runtime, pinned inputs, a non-root process, reproducible provenance, and a deliberate patching workflow."
image:
  url: assets/images/blog/2026-07-19-secure-docker-images-cover.png
  alt: A compact sealed container assembled from a verified chain of minimal layers
---

A small container image is useful because it contains fewer packages to patch and fewer tools to abuse after a compromise. Size itself is not the security property. A tiny, unmaintained base image can be a worse choice than a slightly larger image with clear provenance and prompt updates.

<!--more-->

Use a multi-stage build. Compile and test in a builder stage, then copy only the runtime artifact and required libraries into the final image. Package managers, compilers, source files, and test credentials should not cross that boundary.

Pin the base by digest when reproducibility matters, but pair pinning with an update process. A digest prevents an upstream tag from changing unexpectedly; it also prevents security fixes from arriving automatically. Dependency automation should propose new digests, rebuild the image, scan it, and run the normal tests.

Run the process as a non-root user and make the filesystem read-only where the application permits it. Explicitly declare writable temporary locations. Drop unnecessary Linux capabilities rather than relying on the container boundary as a complete sandbox.

Do not bake secrets into build arguments, environment layers, or copied configuration. Image layers remain inspectable after later instructions remove a file. Supply secrets at runtime through the platform's secret mechanism and keep them out of logs.

Record what was built. An image digest, source revision, dependency inventory, and build provenance make an alert actionable when a vulnerable component is discovered. Scan both during CI and after publication because vulnerability knowledge changes while the image stays the same.

Finally, test the actual final image. A successful builder stage says little about missing certificates, time-zone data, native libraries, or permissions in production. Minimalism is valuable when it is backed by an observable, repeatable supply chain—not when it merely wins an image-size contest.
