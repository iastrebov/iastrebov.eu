# iastrebov.eu

Personal website for Egor Iastrebov, built with Jekyll and deployed through GitHub Pages.

## Local development

Install dependencies:

```bash
bundle install
```

Start the development server:

```bash
bundle exec jekyll serve
```

Build the production site:

```bash
bundle exec jekyll build
```

## Repository structure

- `_config.yml` - site metadata, navigation, and Jekyll defaults
- `_layouts/` - page and post shells
- `_includes/` - shared navigation, sidebar, analytics, and post preview fragments
- `index.html`, `resume.html`, `blog.html`, `contact.html` - public pages
- `_posts/` - blog posts
- `assets/` - styles, scripts, images, and icons

## Blog discovery

The blog uses a native Jekyll generator in `_plugins/blog_discovery.rb`. It keeps
the existing `/blog.html` archive and article URLs, and creates later archive pages
at `/blog/page/2/` and onward. Set `blog.per_page` in `_config.yml` to change the
page size (currently 12). Restart `jekyll serve` after changing configuration.

Ten curated topic indexes are generated from the existing article tags using
`_data/topics.yml`. Add a matching tag to that mapping when introducing a new
subject; the build warns about articles that have no matching topic while keeping
them available in the main archive. Related articles
use shared tags, with publication date and URL as deterministic tie-breakers.
No article text is generated or rewritten by this process.

The custom generator runs with this repository's `bundle exec jekyll build`
workflow; Jekyll's `--safe` mode disables custom plugins.

Archive cards use committed WebP thumbnails. After adding or replacing a cover,
generate its derivative with Python 3 and Pillow:

```bash
python3 scripts/generate_blog_thumbnails.py
```

Regenerate compiled CSS and its portable source map after editing SCSS:

```bash
bundle exec ruby scripts/compile_styles.rb
```

The existing development Docker image can run the Ruby commands above. For example:

```bash
docker run --rm -v "$PWD:/site" iastrebov-eu-jekyll \
  bundle exec ruby scripts/compile_styles.rb
```

Search crawler access, production checks, and the distinction between search and
training crawlers are documented in [the crawler access review](docs/crawler-access.md).

Validate pagination, topic coverage, related articles, and unpublished/future
article handling using the Ruby 3.3 development image:

```bash
docker run --rm -v "$PWD:/site" iastrebov-eu-jekyll \
  ruby scripts/test_blog_discovery.rb
python3 scripts/generate_blog_thumbnails.py --check
```

## Deployment

Pushes to `main` trigger the GitHub Pages workflow in `.github/workflows/jekyll.yml`.
