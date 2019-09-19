require 'set'
require_relative 'lib/repositories/in_memory'
require_relative 'lib/repositories/redis'

class SixDegreesOfWikipedia
  class << self
    def call(from_path, to_path)
      queue = []
      queue.push(Node.new(from_path))

      repository = Repositories::Redis.new

      answer = []

      print "From #{from_path} to #{to_path} "
      while (current = queue.shift) != nil
        return current.previous_plus_current if current.path == to_path

        links = repository.get_links(current.path)

        return (answer = current.previous_plus_current << to_path) if links.include?(to_path)

        links.each do |link|
          queue.push(Node.new(link, current.previous_plus_current)) unless current.previous.include?(link)
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
