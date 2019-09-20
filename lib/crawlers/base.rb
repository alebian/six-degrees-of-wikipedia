module Crawlers
  class Base
    def initialize(from_path, to_path, repository:)
      @from_path = from_path.match?('/wiki/') ? from_path : "/wiki/#{from_path}"
      @to_path = to_path.match?('/wiki/') ? to_path : "/wiki/#{to_path}"
      @repository = repository
    end

    def call
      raise 'Subclass must implement'
    end
  end
end
