require_relative 'wikipedia_crawler'

from_path = '/wiki/Ruby_(programming_language)'
to_path = '/wiki/Chuck_Norris'

answer = WikipediaCrawler.crawl(from_path, to_path)

puts "\n\n#############################################################################\n"
puts "#{from_path} is #{answer.size - 1} degrees separated from #{to_path}."
puts "#############################################################################\n"
puts answer
puts "#############################################################################\n"
