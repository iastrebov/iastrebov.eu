---
layout: post
title: "Secure File Uploads: Content-Type Is User Input Too"
date: 2026-06-18 12:45:00 +0100
categories: software engineering
tags: [security, file-upload, api, backend]
excerpt_separator: <!--more-->
greeting: "a filename is not a storage plan"
description: "Build secure file uploads with allowlists, generated storage names, size limits, content inspection, isolation, and safe download headers."
image:
  url: assets/images/blog/2026-06-18-secure-file-upload-api-cover.png
  alt: "An uploaded file crossing size, type, malware, and isolated-storage security gates"
---
The client controls filename, extension, and `Content-Type`. Treating any of them as trusted metadata turns an upload endpoint into a filesystem and content-delivery attack surface.

<!--more-->

## Allow Only What Product Needs

If users upload profile images, accept a narrow image set. Do not maintain a blacklist of everything dangerous; the list loses.

The [OWASP File Upload Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/File_Upload_Cheat_Sheet.html) recommends extension allowlisting, type validation beyond the spoofable header, generated filenames, size limits, and authorization.

Check file signatures with a maintained parser, then decode and re-encode images when practical. A valid-looking prefix is not proof the remaining bytes are harmless.

## Store Outside Executable Paths

Generate an opaque storage key. Keep the original filename only as sanitized display metadata. Store files outside the application web root or behind a separate object-storage download path.

Serve downloads with a safe `Content-Disposition` and an explicit content type. Keep uploaded HTML or SVG from executing under your trusted origin. If execution is required, isolate it in a deliberately sandboxed feature.

## Bound Every Resource

Enforce request size at the edge and application, bound decompression and image dimensions, stream instead of buffering unlimited bodies, and clean abandoned multipart data.

Malware scanning can be asynchronous, but unscanned objects must remain quarantined. “Upload succeeded” and “content is available” are separate states.


- [Validation Boundaries In Spring: DTO Checks Are Not Domain Rules](/blog/validation-boundaries-spring-api/)
- [The Works On My Machine Excuse Ends Here](/blog/works-on-my-machine-excuse-ends-here/)
