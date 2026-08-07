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

## Deployment

Pushes to `main` trigger the GitHub Pages workflow in `.github/workflows/jekyll.yml`.
