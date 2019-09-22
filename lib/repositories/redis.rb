require 'redis'
require 'oj'
require 'active_support/all'
require_relative '../services/wikipedia'

module Repositories
  class Redis
    REDIS_URL = 'redis://localhost:6379'.freeze

    def initialize
      @connection = ::Redis.new(url: REDIS_URL)
    end

    def get_links(path)
      return Oj.load(@connection.get(path)) if @connection.exists(path)

      links = Services::Wikipedia.article_links(path)
      @connection.set(path, links.to_json)

      links
    end
  end
end
