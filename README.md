[![Build Status](https://travis-ci.org/denmarkmeralpis/api_queries.svg?branch=master)](https://travis-ci.org/denmarkmeralpis/api_queries)
# ApiQueries

Manage you api using `api_q` method.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'api_queries'
gem 'will_paginate', '~> 3.1.0'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install api_queries

## Usage

Add this to the model you want to add an api queries.

```ruby
include ApiQueries
```

Optional Parameters:
- `active_only [1, 0]`
- `page [1 ~ n]`

Get data filtered by date:
- `after`
- `before`
- `from`
- `to`

Available Queries:
- `q=count`
- `q=last_updated_at`

Example:
```ruby
# Get active products(assuming you have a status column)
Product.api_q({ active_only: 1 })

# Get active products and go to page 2
Product.api_q({ active_only: 1, page: 2 })

# Get all dates using from and to
# Date format should be: YYYY-MM-DDTHH:MM:SSZ
Product.api_q({ from: '2016-01-01T12:00:00Z', to: '2016-01-31T12:00:00Z' })

# Count all products
Product.api_q({ q: 'count' })

# Get last updated_at
Product.api_q({ q: 'last_updated_at' })

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/denmarkmeralpis/api_queries. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

