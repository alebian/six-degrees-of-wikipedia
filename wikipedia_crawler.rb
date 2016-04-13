require 'set'
require 'json'
require_relative 'wikipedia_scrapper'

class WikipediaCrawler
  CACHE_FILE = 'wikipedia_cache.json'
  CACHE_TIME_TO_SAVE = 600 # backup every 10 minutes

  class << self
    def crawl(from_path, to_path)
      queue = []
      queue.push(Node.new(from_path))

      cache = load_cache
      last_save = Time.now

      answer = []

      print "From #{from_path} crawling to #{to_path} "
      while (current = queue.shift) != nil
        return current.previous_plus_current if current.path == to_path

        if cache.key?(current.path)
          print 'c'
          internal_links = cache[current.path]
        else
          print '.'
          cache[current.path] = internal_links = WikipediaScrapper.internal_links(current.path)
          last_save = save_cache(cache, last_save)
        end

        return (answer = current.previous_plus_current << to_path) if internal_links.include?(to_path)

        internal_links.each do |link|
          queue.push(Node.new(link, current.previous_plus_current)) unless current.previous.include?(link)
        end
      end
    ensure
      save_cache(cache)
      return answer
    end

    private

    def save_cache(cache, last_save = nil)
      return last_save if !last_save.nil? && (last_save + CACHE_TIME_TO_SAVE) > Time.now
      print 'S'
      File.delete(CACHE_FILE) if File.exist?(CACHE_FILE)
      file = File.open(CACHE_FILE, 'w+')
      file.write(JSON.generate(cache))
      file.close
      Time.now unless last_save.nil?
    end

    def load_cache
      return {} unless File.exist?(CACHE_FILE)
      JSON.parse(File.read(CACHE_FILE))
    end

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
