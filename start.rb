require_relative 'wikipedia_crawler'

from_path = '/wiki/Arnold_Schwarzenegger'
to_path = '/wiki/Chuck_Norris'

answer = SixDegreesOfWikipedia.call(from_path, to_path)

puts "\n\n######################################################################################\n"
puts "#{from_path} is #{answer.size - 1} degrees separated from #{to_path}."
puts "######################################################################################\n"
puts answer
puts "######################################################################################\n"
