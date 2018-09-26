# Rimc

Rimc is dead simple and stupid in memory cache implementation in ruby. It store the cached object in globa  l ruby hash and use lazy cache expiration.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rimc'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rimc

## Usage

To set cache

``` ruby
Rimc.set('cache_key', 'cached object', 60) # Set cache ttl 60 seconds
```

To get the cached object
``` ruby
Rimc.get('cache_key') # => return the cached object
```

Or you can use it with block style
```ruby
Rimc.cache('cache_key', 60) do
    do_something_first
    and_then_do_this
    and_done
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/feualpha/rimc. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
