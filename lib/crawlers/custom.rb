require_relative 'base'

module Crawlers
  class Custom < Base
    def call
      queue = []
      queue.push(Node.new(@from_path))

      answer = []

      # print 'Started searching.'
      while (current = queue.shift) != nil
        return current.complete_articles_path if current.article == @to_path

        links = @repository.get_links(current.article)

        if links.include?(@to_path)
          # puts 'Found'
          return (answer = current.complete_articles_path << @to_path)
        end

        links.each do |article|
          # TODO: this search might be improved by using a hash
          unless current.previous_articles.include?(article)
            # print '.'
            queue.push(Node.new(article, current.complete_articles_path))
          end
        end
      end

      answer
    end

    class Node
      attr_reader :article, :previous_articles

      def initialize(article, previous_articles = [])
        @article = article
        @previous_articles = previous_articles
      end

      def complete_articles_path
        @previous_articles + [@article]
      end
    end
  end
end
