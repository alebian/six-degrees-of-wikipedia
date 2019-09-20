require_relative 'base'

module Crawlers
  class Custom < Base
    def call
      queue = Queue.new
      queue.push(Node.new(@from_path))

      answer = []

      # print 'Started searching.'
      while (current = queue.pop) != nil
        return current.previous_plus_current if current.path == @to_path

        links = @repository.get_links(current.path)

        if links.include?(@to_path)
          # puts 'Found'
          return (answer = current.previous_plus_current << @to_path)
        end

        links.each do |link|
          unless current.previous.include?(link)
            # print '.'
            queue.push(Node.new(link, current.previous_plus_current))
          end
        end
      end

      answer
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
