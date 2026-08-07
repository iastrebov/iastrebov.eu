# AGENTS.md

## Project Snapshot
- Repository type: static personal website built with Jekyll.
- Runtime/build: Ruby + Bundler + Jekyll (`jekyll 4.3.x`).
- Deployment: GitHub Pages workflow in `.github/workflows/jekyll.yml` on pushes to `main`.

## Repository Map
- Site config: `_config.yml`
- Layouts: `_layouts/`
  - `_layouts/default.html` is the main shell (head, assets, sidebar, menu).
  - `_layouts/base.html` wraps normal pages and injects page title block.
  - `_layouts/post.html` renders blog posts and expects post metadata.
- Includes: `_includes/` (menu, sidebar, post cards, analytics, comments).
- Content pages: `index.html`, `blog.html`, `resume.html`, `contact.html`, `404.html`
- Posts: `_posts/`
- Assets:
  - Styles: `assets/styles/` (SCSS source + compiled CSS)
  - Scripts: `assets/js/`
  - Images/icons: `assets/images/`, `assets/icons/`

## Local Development

Docker is the recommended local workflow because it provides the required Ruby
and Bundler versions without installing them on the host.

Build the development image once:

```bash
docker build -t iastrebov-eu-jekyll .
```

Start the site with the repository mounted into the container:

```bash
docker run --rm -it \
  --name iastrebov-eu-jekyll \
  -p 4000:4000 \
  -p 35729:35729 \
  -v "$PWD:/site" \
  iastrebov-eu-jekyll
```

Open <http://localhost:4000>. Jekyll watches the mounted source tree using
`--force_polling`, rebuilds the site after edits, and LiveReload refreshes the
browser automatically. Changes to pages, layouts, includes, styles, posts, or
configuration are therefore visible without restarting the container in most
cases. If `_config.yml` changes, restart the container because Jekyll does not
reload configuration changes.

When `Gemfile` or `Gemfile.lock` changes, rebuild the image before starting it:

```bash
docker build --pull -t iastrebov-eu-jekyll .
```

Build-only validation:

```bash
docker run --rm \
  -v "$PWD:/site" \
  iastrebov-eu-jekyll \
  bundle exec jekyll build
```

If Ruby and Bundler are already installed on the host, the equivalent native
commands are `bundle install`, `bundle exec jekyll serve`, and
`bundle exec jekyll build`.

Notes:
- If `_config.yml` changes, restart `jekyll serve` (Jekyll does not hot-reload config).
- Templates use many absolute asset URLs via `{{ site.url }}`; local behavior may differ from production URLs.

## Editing Rules
- Keep layout chain intact:
  - Standard pages use `layout: base`.
  - Posts use `layout: post` (or rely on `_config.yml` defaults).
- Navigation menu is driven by `_config.yml` under `navigation:`; update there instead of hardcoding links.
- Prefer editing shared includes/layouts over duplicating markup across page files.
- Do not modify generated/vendor bundles unless explicitly required:
  - `assets/styles/vendors/bootstrap.min.css`
  - `assets/styles/vendors/*`

## Post Authoring Conventions
- Post filenames should follow `YYYY-MM-DD-title.markdown` (or `.html`) in `_posts/`.
- `_posts/` may be intentionally empty; keep `Blog` navigation intact even when there are no posts.
- Include YAML front matter at minimum:
  - `title`
  - `date`
  - `excerpt_separator: <!--more-->`
- Recommended for this theme (prevents broken visuals in post pages):
  - `greeting`
  - `image.url`
  - `image.alt`

Suggested post front matter template:
```yaml
---
layout: post
title: "Post title"
date: 2026-02-14 10:00:00 +0000
categories: jekyll update
excerpt_separator: <!--more-->
greeting: hello
image:
  url: assets/images/social.jpg
  alt: Cover image
---
```

## Styles and Scripts
- Style source-of-truth is SCSS in `assets/styles/style.scss` and `assets/styles/app/*.scss`.
- `assets/styles/style.css` is compiled output; keep it in sync when editing SCSS.
- `assets/js/common.js` contains the mobile contact toggle and back-to-top behavior.

## Validation Checklist Before Finishing
- Run `bundle exec jekyll build` successfully.
- For UI/content changes, verify at least:
  - `/` (about page)
  - `/resume`
  - `/blog` (empty state or post card list)
  - `/contact`
- If posts exist, verify at least one post detail page under `/blog/...`.
- If touching `_config.yml`, verify server restart behavior and resulting navigation/permalink changes.

## Deployment Notes
- GitHub Pages deploy is automated from `main`.
- Keep changes deterministic and repository-contained; avoid environment-specific absolute local paths.
