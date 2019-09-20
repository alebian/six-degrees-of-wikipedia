# Six degrees of Wikipedia

## Usage

Download the files and then you can do something like:

```ruby
require_relative 'lib/crawlers/graph'
require_relative 'lib/repositories/redis'

repository = Repositories::Redis.new
from_path = 'Chuck_Norris'
to_path = 'Jimmy_Fallon'

answer = Crawlers::Graph.new(from_path, to_path, repository: repository).call
```

![alt tag](https://raw.githubusercontent.com/alebian/six-degrees-of-wikipedia/master/result_example.png)

There is no validation of the given paths. Also the base URL is set to 'https://en.wikipedia.org'. The result is an array of the paths (in order) that it took to get to the destination including the first and the destination.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Run rubocop lint (`rubocop -R --format simple`)
5. Run rspec tests (`bundle exec rspec`)
6. Push your branch (`git push origin my-new-feature`)
7. Create a new Pull Request
