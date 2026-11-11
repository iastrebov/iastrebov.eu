# frozen_string_literal: true

# Run with `ruby scripts/test_blog_discovery.rb` inside the Ruby 3.3 development
# image. Include Ruby's bundled gems even when the container uses a separate
# GEM_PATH for site dependencies; no production dependency is needed.
Gem.use_paths(Gem.dir, Gem.default_path + Gem.path)
gem "minitest"
require "minitest/autorun"
require "bundler/setup"
require "jekyll"
require "tmpdir"
require "fileutils"
require "yaml"
require_relative "../_plugins/blog_discovery"

class BlogDiscoveryTest < Minitest::Test
  ROOT = File.expand_path("..", __dir__)

  def setup
    @temporary = Dir.mktmpdir("blog-discovery-")
    @source = File.join(@temporary, "source")
    %w[_posts _layouts _includes _data].each do |directory|
      FileUtils.mkdir_p(File.join(@source, directory))
    end
    %w[blog.html _layouts/topic.html _layouts/topics.html
       _includes/topic-nav.html _includes/pagination.html
       _includes/post-preview.html].each do |path|
      FileUtils.cp(File.join(ROOT, path), File.join(@source, path))
    end
    File.write(File.join(@source, "_layouts/base.html"), "{{ content }}")
    File.write(File.join(@source, "_data/topics.yml"), YAML.dump([
      { "slug" => "java", "title" => "Java", "tags" => ["java"] },
      { "slug" => "databases", "title" => "Databases", "tags" => ["database"] }
    ]))
  end

  def teardown
    FileUtils.remove_entry(@temporary)
  end

  def write_post(slug, date: "2026-01-01", tags: ["java"], published: true)
    metadata = {
      "title" => slug, "date" => "#{date} 09:00:00 +0000",
      "description" => "Description for #{slug}", "tags" => tags,
      "published" => published
    }
    File.write(File.join(@source, "_posts", "#{date}-#{slug}.markdown"),
               "#{YAML.dump(metadata)}---\n\nArticle #{slug}.\n")
  end

  def build(per_page: 12)
    configuration = Jekyll.configuration(
      "source" => @source, "destination" => File.join(@temporary, "output"),
      "quiet" => true, "plugins" => [], "future" => false, "unpublished" => false,
      "url" => "https://example.test", "blog" => { "per_page" => per_page },
      "time" => Time.utc(2026, 11, 11),
      "defaults" => [{ "scope" => { "path" => "", "type" => "posts" },
                       "values" => { "permalink" => "/blog/:title/" } }]
    )
    site = Jekyll::Site.new(configuration)
    site.process
    site
  end

  def archives(site)
    site.pages.select { |page| page.data["pagination"] }
        .sort_by { |page| page.data["pagination"]["page"] }
  end

  def test_empty_blog_still_renders_one_archive_and_topics_overview
    site = build
    pages = archives(site)
    assert_equal ["/blog.html"], pages.map(&:url)
    assert_equal 0, pages.first.data["pagination"]["total_posts"]
    assert_empty pages.first.data["pagination"]["posts"]
    assert_includes pages.first.output, "No articles have been published yet."
    assert_empty site.config["blog_topics"]
    assert site.pages.any? { |page| page.url == "/blog/topics/" }
  end

  def test_single_post_preserves_archive_url_without_pagination_controls
    write_post("one-post")
    site = build
    page = archives(site).first
    assert_equal ["/blog.html"], archives(site).map(&:url)
    assert_nil page.data["pagination"]["previous_page_path"]
    assert_nil page.data["pagination"]["next_page_path"]
    refute_includes page.output, "Blog pagination"
    assert_equal ["java"], site.config["blog_topics"].map { |topic| topic["slug"] }
    assert_equal ["java"], site.posts.docs.first.data["topics"].map { |topic| topic["slug"] }
    assert_empty site.posts.docs.first.data["related_articles"]
  end

  def test_multiple_pages_cover_every_post_once_and_link_back_to_first_archive
    25.times { |index| write_post(format("post-%02d", index), date: format("2026-01-%02d", index + 1)) }
    site = build
    pages = archives(site)
    assert_equal ["/blog.html", "/blog/page/2/", "/blog/page/3/"], pages.map(&:url)
    assert_equal [12, 12, 1], pages.map { |page| page.data["pagination"]["posts"].length }
    listed = pages.flat_map { |page| page.data["pagination"]["posts"] }
    assert_equal 25, listed.map(&:url).uniq.length
    assert_equal site.posts.docs.map(&:url).sort, listed.map(&:url).sort
    assert_equal listed.map(&:date).sort.reverse, listed.map(&:date)
    assert_equal "/blog.html", pages[1].data["pagination"]["previous_page_path"]
    assert_nil pages.last.data["pagination"]["next_page_path"]
    pages.each { |page| assert_includes pages.first.output, %(href="#{page.url}") unless page.url == "/blog.html" }
    assert_equal 3, pages.map { |page| page.data["title"] }.uniq.length
    assert_equal 3, pages.map { |page| page.data["description"] }.uniq.length
    topic = site.pages.find { |page| page.url == "/blog/topics/java/" }
    assert_equal listed.map(&:url).sort, topic.data["topic"]["posts"].map(&:url).sort
  end

  def test_future_and_unpublished_articles_never_leak_into_discovery_pages
    write_post("visible")
    write_post("future-secret", date: "2099-01-01")
    write_post("unpublished-secret", published: false)
    site = build
    assert_equal ["visible"], site.posts.docs.map { |post| post.data["title"] }
    assert_equal 1, archives(site).first.data["pagination"]["total_posts"]
    site.pages.each do |page|
      refute_includes page.output, "future-secret"
      refute_includes page.output, "unpublished-secret"
    end
    assert_empty site.posts.docs.first.data["related_articles"]
  end

  def test_related_articles_exclude_self_and_use_stable_tie_breaking
    %w[target bravo alpha charlie delta].each { |slug| write_post(slug) }
    site = build
    target = site.posts.docs.find { |post| post.data["title"] == "target" }
    assert_equal %w[alpha bravo charlie], target.data["related_articles"].map { |post| post.data["title"] }
    refute_includes target.data["related_articles"], target
  end

  def test_unknown_and_optional_tags_do_not_block_publication
    write_post("unmapped", tags: ["unknown-topic"])
    write_post("untagged", tags: nil)
    path = File.join(@source, "_posts", "2026-01-01-untagged.markdown")
    File.write(path, File.read(path).sub(/^tags:.*\n/, ""))
    write_post("known", tags: ["java"])
    site = build(per_page: 2)
    assert_equal [2, 1], archives(site).map { |page| page.data["pagination"]["posts"].length }
    assert_equal %w[known unmapped untagged],
                 archives(site).flat_map { |page| page.data["pagination"]["posts"] }
                               .map { |post| post.data["title"] }.sort
    %w[unmapped untagged].each do |title|
      post = site.posts.docs.find { |candidate| candidate.data["title"] == title }
      assert_empty post.data["topics"]
      assert File.exist?(post.destination(site.dest))
    end
    topic = site.pages.find { |page| page.url == "/blog/topics/java/" }
    assert_equal ["known"], topic.data["topic"]["posts"].map { |post| post.data["title"] }
  end

  def test_non_positive_page_size_fails_before_writing_broken_archives
    write_post("one-post")
    error = assert_raises(Jekyll::Errors::FatalException) { build(per_page: 0) }
    assert_includes error.message, "blog.per_page must be positive"
  end
end
