# frozen_string_literal: true

# Generate crawlable archives without moving the existing /blog.html URL.
# jekyll-paginate requires an index.html source; this generator also creates the
# curated topic pages using the same Jekyll page and document objects.
module BlogDiscovery
  class Generator < Jekyll::Generator
    safe true
    priority :normal

    def generate(site)
      posts = site.posts.docs.sort_by { |post| [-post.date.to_f, post.url] }
      topics = build_topics(site, posts)
      site.config["blog_topics"] = topics.map { |topic| topic.reject { |key, _| key == "posts" } }

      posts.each do |post|
        post.data["topics"] = site.config["blog_topics"].select do |topic|
          topics.find { |entry| entry["slug"] == topic["slug"] }["posts"].include?(post)
        end
        post.data["related_articles"] = related_articles(post, posts)
      end

      generate_archive(site, posts)
      generate_topics(site, topics)
    end

    private

    def build_topics(site, posts)
      topics = Array(site.data["topics"]).map do |topic|
        matching_posts = posts.select do |post|
          (Array(post.data["tags"]) & Array(topic["tags"])).any?
        end
        topic.merge("url" => "/blog/topics/#{topic['slug']}/", "posts" => matching_posts,
                    "count" => matching_posts.length)
      end

      uncovered = posts.reject { |post| topics.any? { |topic| topic["posts"].include?(post) } }
      unless uncovered.empty?
        names = uncovered.map(&:relative_path).join(", ")
        Jekyll.logger.warn "Blog topics:",
                           "Articles remain in the archive but have no matching topic. " \
                           "Add matching tags in _data/topics.yml if needed: #{names}"
      end

      topics.reject { |topic| topic["posts"].empty? }
    end

    def related_articles(post, posts)
      tags = Array(post.data["tags"])
      posts.reject { |candidate| candidate == post }.map do |candidate|
        [candidate, (tags & Array(candidate.data["tags"])).length]
      end.select { |_, overlap| overlap.positive? }
           .sort_by { |candidate, overlap| [-overlap, -candidate.date.to_f, candidate.url] }
           .first(3).map(&:first)
    end

    def generate_archive(site, posts)
      archive = site.pages.find { |page| page.relative_path == "blog.html" }
      return unless archive

      per_page = Integer(site.config.fetch("blog", {}).fetch("per_page", 12))
      raise Jekyll::Errors::FatalException, "blog.per_page must be positive" unless per_page.positive?

      total_pages = [(posts.length.to_f / per_page).ceil, 1].max
      page_links = (1..total_pages).map { |number| { "number" => number, "url" => archive_url(number) } }
      source_data = archive.data.dup

      (1..total_pages).each do |number|
        page = if number == 1
                 archive
               else
                 generated_page(site, "blog/page/#{number}", source_data, archive.content)
               end
        page.data["blog_index"] = true
        page.data["pagination"] = {
          "page" => number, "per_page" => per_page, "total_posts" => posts.length,
          "total_pages" => total_pages, "pages" => page_links,
          "posts" => posts.slice((number - 1) * per_page, per_page) || [],
          "previous_page_path" => number > 1 ? archive_url(number - 1) : nil,
          "next_page_path" => number < total_pages ? archive_url(number + 1) : nil
        }
        next if number == 1

        page.data["title"] = "#{source_data['title']} — Page #{number}"
        page.data["description"] = "#{source_data['description']} Page #{number} of #{total_pages}."
      end
    end

    def archive_url(number)
      number == 1 ? "/blog.html" : "/blog/page/#{number}/"
    end

    def generate_topics(site, topics)
      generated_page(site, "blog/topics", {
        "layout" => "topics", "title" => "Blog Topics", "blog_index" => true,
        "description" => "Browse Egor Iastrebov's engineering articles by topic."
      })
      topics.each do |topic|
        generated_page(site, "blog/topics/#{topic['slug']}", {
          "layout" => "topic", "title" => topic["title"], "description" => topic["description"],
          "topic" => topic, "blog_index" => true
        })
      end
    end

    def generated_page(site, directory, data, content = "")
      page = Jekyll::PageWithoutAFile.new(site, site.source, directory, "index.html")
      page.content = content
      page.data.merge!(data)
      # A source permalink must not make the generated pages overwrite each other.
      page.data["permalink"] = "/#{directory}/"
      site.pages << page
      page
    end
  end
end
