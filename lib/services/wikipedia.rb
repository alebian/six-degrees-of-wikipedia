require 'nokogiri'
require 'open-uri'

module Services
  class Wikipedia
    BASE_URL = 'https://en.wikipedia.org'.freeze

    class << self
      def article_links(article)
        article = get_article(article)

        article.css('a').each_with_object([]) do |link, array|
          href = link['href']
          array << href if internal?(href) && !array.include?(href)
          array
        end
      end

      private

      def get_article(article)
        uri = URI.parse("#{BASE_URL}#{article}")
        Nokogiri::HTML(uri.read)
      end

      def internal?(link)
        link =~ /^\/wiki\/*/ && !link.include?(':') && link != '/wiki/Main_Page'
      end
    end
  end
end
