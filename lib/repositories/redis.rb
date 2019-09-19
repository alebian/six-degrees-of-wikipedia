require 'redis'
require 'json'
require_relative '../services/wikipedia'

module Repositories
  class Redis
    REDIS_URL = 'redis://localhost:6379'.freeze

    def initialize
      @connection = ::Redis.new(url: REDIS_URL)
    end

    def get_links(path)
      return JSON.parse(@connection.get(path)) if @connection.exists(path)

      links = Services::Wikipedia.article_links(path)
      @connection.set(path, links.to_s)

      links
    end
  end
end
