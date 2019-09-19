require 'json'
require_relative '../services/wikipedia'

module Repositories
  class InMemory
    CACHE_FILE = './wikipedia_cache.json'.freeze
    CACHE_TIME_TO_SAVE = 60 # backup every 10 minutes

    def initialize
      @cache = load_cache
      @last_save = Time.now
    end

    def get_links(path)
      return @cache[path] if @cache.key?(path)

      @cache[path] = Services::Wikipedia.article_links(path)
      save_cache!

      @cache[path]
    end

    private

    def load_cache
      return {} unless File.exist?(CACHE_FILE)

      JSON.parse(File.read(CACHE_FILE))
    end

    def save_cache!
      return if (@last_save + CACHE_TIME_TO_SAVE) > Time.now

      File.delete(CACHE_FILE) if File.exist?(CACHE_FILE)
      file = File.open(CACHE_FILE, 'w')
      file.write(JSON.generate(@cache))
      file.close
      @last_save = Time.now
    end
  end
end
