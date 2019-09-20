require 'rgl/adjacency'
require 'rgl/traversal'
require 'rgl/dijkstra'
require_relative 'base'

module Crawlers
  class Graph < Base
    def call
      graph = RGL::DirectedAdjacencyGraph.new

      queue = []
      queue.push(@from_path)

      # print 'Started searching.'
      while (current = queue.shift) != nil
        links = @repository.get_links(current)

        links.each do |link|
          unless graph.has_vertex?(link)
            # print '.'
            graph.add_edge(current, link)
            queue.push(link)
          end
        end

        if links.include?(@to_path)
          # puts 'Found'
          return graph.dijkstra_shortest_path(EdgeWeightHack.new, @from_path, @to_path)
        end
      end
    end

    class EdgeWeightHack
      # The dijkstra_shortest_path expects a hash
      def [](key)
        1
      end
    end
  end
end
