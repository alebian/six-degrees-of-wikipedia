require 'nokogiri'
require 'open-uri'

class Wikipedia
  BASE_URL = 'https://en.wikipedia.org'.freeze

  class << self
    def article_links(wikipedia_path)
      site = Nokogiri::HTML(open("#{BASE_URL}#{wikipedia_path}").read)
      site.css('a').each_with_object([]) do |link, array|
        array << link['href'] if internal?(link['href']) && !array.include?(link['href'])
        array
      end
    end

    private

    def internal?(link)
      link =~ /^\/wiki\/*/ && !link.include?(':') && link != '/wiki/Main_Page'
    end
  end
end
