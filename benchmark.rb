require_relative 'lib/crawlers/custom'
require_relative 'lib/crawlers/graph'
require_relative 'lib/repositories/redis'
require_relative 'lib/repositories/in_memory'

require 'benchmark'
require 'memory_profiler'

N = 100
FROM_PATH = 'Chuck_Norris'
TO_PATH = 'Computer_programming'

# Run once to get the results in cache
Crawlers::Graph.new(FROM_PATH, TO_PATH, repository: Repositories::Redis.new).call

# https://gist.github.com/alebian/724144c98f269d3f0407986f0a8be949
PROCS = [
  [
    "Custom",
    -> { Crawlers::Custom.new(FROM_PATH, TO_PATH, repository: Repositories::Redis.new).call }
  ],
  [
    "Graph ",
    -> { Crawlers::Graph.new(FROM_PATH, TO_PATH, repository: Repositories::Redis.new).call }
  ]
]

puts("Benchmarking #{N} times\n\n")

Benchmark.bm do |x|
  PROCS.each do |(description, proc)|
    x.report(description) do
      N.times { proc.call }
    end
  end
end

puts("\n")

PROCS.each do |(description, proc)|
  puts "Memory usage of #{description} ".ljust(50, '-')
  report = MemoryProfiler.report do
    proc.call
  end
  puts "\tTotal allocated: #{report.total_allocated_memsize} bytes (#{report.total_allocated} objects)"
  puts "\tTotal retained: #{report.total_retained_memsize} bytes (#{report.total_retained} objects)"
end
