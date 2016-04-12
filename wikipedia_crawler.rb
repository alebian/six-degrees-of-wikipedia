require 'set'
require_relative 'wikipedia_scrapper'

class WikipediaCrawler
  class << self
    def crawl(from_path, to_path)
      searched = Set.new
      queue = []
      queue.push(Node.new(from_path))

      print 'Crawling'
      while (current = queue.shift) != nil
        print '.'
        internal_links = WikipediaScrapper.internal_links(current.path)
        searched.add(current.path)

        return current.previous_plus_current if current.path == to_path

        internal_links.each do |link|
          queue.push(Node.new(link, current.previous_plus_current)) unless searched.include?(link)
        end
      end
    end

    private

    class Node
      attr_reader :path, :previous, :previous_intents

      def initialize(path, previous = [])
        @path = path
        @previous = previous
        @previous_intents = previous.size
      end

      def previous_plus_current
        new_array = []
        new_array.concat(@previous)
        new_array << @path
      end
    end
  end
end
