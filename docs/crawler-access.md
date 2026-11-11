# Search crawler access review

Checked against production on 2026-11-11 at approximately 14:48 UTC, before these changes are deployed.

## Live access

Read-only HTTPS requests were made from the development environment using the user-agent names below. Every request returned HTTP 200. All user agents received the same response sizes, and no response contained an `X-Robots-Tag` header.

| User agent | `/robots.txt` | `/` | `/blog` | `/blog/ai-supervised-human-owned/` |
| --- | --- | --- | --- | --- |
| `Mozilla/5.0` (comparison) | 200 | 200 | 200 | 200 |
| `Googlebot` | 200 | 200 | 200 | 200 |
| `OAI-SearchBot` | 200 | 200 | 200 | 200 |
| `GPTBot` | 200 | 200 | 200 | 200 |
| `ChatGPT-User` | 200 | 200 | 200 | 200 |
| `ClaudeBot` | 200 | 200 | 200 | 200 |
| `Claude-SearchBot` | 200 | 200 | 200 | 200 |
| `Claude-User` | 200 | 200 | 200 | 200 |
| `PerplexityBot` | 200 | 200 | 200 | 200 |
| `Perplexity-User` | 200 | 200 | 200 | 200 |

The production `robots.txt` contained only:

```text
Sitemap: https://iastrebov.eu/sitemap.xml
```

There were no crawler exclusions. The new repository-owned `robots.txt` makes search access explicit and retains a permissive wildcard rule. It preserves the existing policy for training crawlers and user-directed retrieval rather than introducing a new training preference.

Both the extensionless and `.html` forms of `/blog`, `/resume`, and `/contact` returned HTTP 200 directly. Each pair already declared the `.html` URL as canonical. Their HTML contained no robots meta directive. The sample article, sitemap, and feed also returned HTTP 200. Internal links now follow the existing canonical URLs while the published extensionless aliases remain available.

These requests establish that no user-agent-based block was observed from this environment. They do **not** originate from verified Google, OpenAI, Anthropic, or Perplexity crawler IP addresses. IP-based restrictions, actual crawler visits, indexing, and citation eligibility cannot be proved by changing a request's user-agent string. Search Console, Bing Webmaster Tools, provider diagnostics, or verified request logs are needed for those checks. This repository does not control a separate CDN or firewall configuration.

## Search and training are separate

- Google Search discovery uses `Googlebot`.
- OpenAI search uses `OAI-SearchBot`; `GPTBot` is for possible model-training use. `ChatGPT-User` represents user-initiated requests and is not the search indexing control.
- Anthropic search uses `Claude-SearchBot`; `Claude-User` retrieves pages for user requests. `ClaudeBot` is the training-related crawler.
- Perplexity search uses `PerplexityBot`; `Perplexity-User` retrieves pages for user requests. Perplexity documents that neither is a foundation-model training crawler.

Provider documentation:

- [Google robots.txt introduction](https://developers.google.com/search/docs/crawling-indexing/robots/intro)
- [OpenAI crawlers](https://developers.openai.com/api/docs/bots)
- [Anthropic crawler controls](https://privacy.claude.com/en/articles/8896518-does-anthropic-crawl-data-from-the-web-and-how-can-site-owners-block-the-crawler)
- [Perplexity crawlers](https://docs.perplexity.ai/docs/resources/perplexity-crawlers)

## Archive images

The original article cover files remain unchanged. Archive cards use generated WebP derivatives when available and fall back to the original image for future posts without a derivative. The generated manifest supplies each thumbnail's actual dimensions. Native lazy loading and asynchronous decoding avoid requiring JavaScript for image loading.

The 141 originals total approximately 201.8 MiB; their generated thumbnails total approximately 3.4 MiB, a reduction of about 98.3% in the assets referenced by archive cards. This is an asset-size comparison, not a measurement of a particular browser session's transfer.

To regenerate after adding or replacing covers, install Pillow in your development Python environment and run:

```bash
python3 scripts/generate_blog_thumbnails.py
```

To check whether committed derivatives and their manifest are current:

```bash
python3 scripts/generate_blog_thumbnails.py --check
```

Generation preserves aspect ratio, limits dimensions to 640 pixels, and writes to `assets/images/blog/thumbnails/` and `_data/blog_thumbnails.yml`. It never writes to the source covers. `scripts/` and this documentation are excluded from the published site.
