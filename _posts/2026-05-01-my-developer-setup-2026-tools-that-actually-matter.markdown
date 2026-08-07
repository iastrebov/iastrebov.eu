---
layout: post
title: "My Developer Setup 2026: Tools That Actually Matter"
date: 2026-05-01 15:49:00 +0100
categories: software engineering
tags: [developer-tools, setup, productivity, tdd]
excerpt_separator: <!--more-->
greeting: "less sparkle, more flow"
description: "A practical 2026 developer setup focused on IntelliJ IDEA, terminal speed, AI plugins, hardware, and tools that support TDD workflow."
image:
  url: assets/images/blog/2026-05-01-my-developer-setup-2026-tools-that-actually-matter-cover.png
  alt: "Dark-mode IDE on ultrawide monitor with minimal desk and precise terminal panels"
---
Developer setup is not desk aesthetics competition. If tool does not reduce friction, improve feedback, or protect focus, it is decoration.

My 2026 setup is boring on purpose: strong IDE, fast terminal, good keyboard, reliable tests, and AI where it actually helps.

<!--more-->

## IDE

IntelliJ IDEA Ultimate for Java backend. Not because real engineers cannot use Vim. Because for large JVM codebases, navigation, refactoring, debugger, database tools, and Spring support pay rent every day.

Key rule: learn shortcuts. If you use mouse for everything, you bought race car and push it by hand.

Important actions: search everywhere, go to declaration, find usages, rename refactor, extract method, run test at cursor, recent files, generate test.

## Terminal

Terminal must be boring fast. I use zsh, good prompt, ripgrep, fd, jq, curl, git aliases, and SDK manager or asdf-style tool management depending on machine.

No ten-layer prompt that renders calendar, weather, and emotional state. Prompt should tell branch, status, and path. Done.

## Git

Small commits. Clear messages. Branch per unit of work. Review diff before push.

Tools help, but discipline matters more. If you cannot explain your diff, no tool saves you.

## AI Tools

AI assistant is useful for boilerplate, test scaffolding, regex, documentation drafts, and exploring unfamiliar APIs.

I do not let AI commit code without reading. I do not accept generated tests that only mirror implementation. I ask AI for alternatives, then choose.

AI is pair programmer with memory loss and confidence problem. Treat accordingly.

## Hardware

Good keyboard. Comfortable chair. External monitor if you read many logs and diffs. Enough RAM that Docker, IDE, browser, and database can run without drama.

Do not buy RGB nonsense before buying backup drive and decent chair.

## TDD Feedback Loop

Setup must make tests easy to run.

- Unit test from IDE shortcut.
- Full module test from terminal.
- Watch mode where project supports it.
- Coverage only when useful.
- Fast failure visible in editor.

If running test is annoying, people run fewer tests. Then quality becomes motivational poster.

## Browser And API Tools

Use HTTP files in IDE, curl, or Bruno/Postman if team standard. Keep examples versioned. Random manual request history is not documentation.

## What I Avoid

I avoid tool churn. New terminal every month, new note app every quarter, new theme every week. This is productivity cosplay.

Master small set of reliable tools. Your brain cache matters.

## Final Setup Principle

The best setup disappears. It keeps you close to code, tests, docs, logs, and production signals.

Everything else is desk theater.

## Related reading

- [The Works On My Machine Excuse Ends Here](/blog/works-on-my-machine-excuse-ends-here/)
- [AI Won't Replace You, But I Will If You Use It Like A Junior](/blog/ai-wont-replace-you-but-i-will-if-you-use-it-like-a-junior/)
