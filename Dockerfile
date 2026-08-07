FROM ruby:3.3-bookworm

ENV BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_APP_CONFIG=/usr/local/bundle \
    JEKYLL_ENV=development

WORKDIR /site

# Install locked dependencies in the image layer so source edits do not
# trigger a reinstall when the repository is bind-mounted at runtime.
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 4000 35729

# Polling is required for reliable file watching through Docker bind mounts.
# LiveReload refreshes the browser after Jekyll regenerates the site.
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--port", "4000", "--livereload", "--force_polling"]
