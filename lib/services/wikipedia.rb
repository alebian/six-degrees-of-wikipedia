require 'nokogiri'
require 'open-uri'

module Services
  class Wikipedia
    BASE_URL = 'https://en.wikipedia.org'.freeze

    class << self
      def article_links(wikipedia_path)
        article = get_article(wikipedia_path)

        article.css('a').each_with_object([]) do |link, array|
          href = link['href']
          array << href if internal?(href) && !array.include?(href)
          array
        end
      end

      private

      def get_article(path)
        Nokogiri::HTML(open("#{BASE_URL}#{path}").read)
      end

      def internal?(link)
        link =~ /^\/wiki\/*/ && !link.include?(':') && link != '/wiki/Main_Page'
      end
    end
  end
end
