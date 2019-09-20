require_relative 'lib/crawlers/custom'
require_relative 'lib/crawlers/graph'
require_relative 'lib/repositories/redis'
require_relative 'lib/repositories/in_memory'

REPOSITORIES = {
  redis: Repositories::Redis,
  in_memory: Repositories::InMemory
}.freeze

CRAWLERS = {
  custom: Crawlers::Custom,
  graph: Crawlers::Graph
}.freeze

repository = REPOSITORIES.fetch(repository || :redis).new
from_path = 'Chuck_Norris'
to_path = 'Jimmy_Fallon'

answer = CRAWLERS.fetch(:graph).new(from_path, to_path, repository: repository).call

puts "\n\n######################################################################################\n"
puts "#{from_path} is #{answer.size - 1} degrees separated from #{to_path}."
puts "######################################################################################\n"
puts answer
puts "######################################################################################\n"
