# frozen_string_literal: true

# Run with: bundle exec ruby scripts/compile_styles.rb
require "json"
require "pathname"
require "sass-embedded"
require "uri"

styles = File.expand_path("../assets/styles", __dir__)
result = Sass.compile(File.join(styles, "style.scss"), style: :expanded,
                      source_map: true, logger: Sass::Logger.silent)
source_map = JSON.parse(result.source_map)
source_map["sources"] = source_map.fetch("sources").map do |source|
  path = URI::DEFAULT_PARSER.unescape(URI.parse(source).path)
  Pathname.new(path).relative_path_from(Pathname.new(styles)).to_s
end
source_map["file"] = "style.css"

File.write(File.join(styles, "style.css"), result.css + "\n/*# sourceMappingURL=style.css.map */\n")
File.write(File.join(styles, "style.css.map"), JSON.generate(source_map) + "\n")
