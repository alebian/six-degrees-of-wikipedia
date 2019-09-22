require_relative 'lib/crawlers/custom'
require_relative 'lib/crawlers/graph'
require_relative 'lib/repositories/redis'
require_relative 'lib/repositories/in_memory'

repository = Repositories::Redis.new
from_path = 'Chuck_Norris'
to_path = 'Computer_programming'

answer = Crawlers::Graph.new(from_path, to_path, repository: repository).call

puts "\n######################################################################################\n"
puts "#{from_path} is #{answer.size - 1} degrees separated from #{to_path}."
puts "######################################################################################\n"
puts answer
puts "######################################################################################\n"
