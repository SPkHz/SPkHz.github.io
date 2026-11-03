require 'nokogiri'

module Jekyll
  module SearchText
    # Inline announcements have already been rendered as HTML. Decode that layer
    # once before Liquid escapes the plain search title for the browser renderer.
    def rendered_search_text(value)
      Nokogiri::HTML.fragment(value.to_s).text.gsub(/\s+/, ' ').strip
    end
  end
end

Liquid::Template.register_filter(Jekyll::SearchText)
