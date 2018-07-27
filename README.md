[![Build Status](https://travis-ci.org/denmarkmeralpis/api_queries.svg?branch=master)](https://travis-ci.org/denmarkmeralpis/api_queries) [![Maintainability](https://api.codeclimate.com/v1/badges/93675db98a1701fb4686/maintainability)](https://codeclimate.com/github/denmarkmeralpis/api_queries/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/93675db98a1701fb4686/test_coverage)](https://codeclimate.com/github/denmarkmeralpis/api_queries/test_coverage) [![Gem Version](https://badge.fury.io/rb/api_queries.svg)](https://badge.fury.io/rb/api_queries)
# ApiQueries

Manage you api using `api_q` method.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'api_queries'
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
# models/product.rb
class Product < ActiveRecord::Base
    include ApiQueries
end

# Get active products(assuming you have a status column)
Product.api_q(active_only: 1)

# Get active products and go to page 2
Product.api_q(active_only: 1, page: 2)

# Get all dates using from and to
# Date format should be: YYYY-MM-DDTHH:MM:SSZ
Product.api_q(from: '2016-01-01T12:00:00Z', to: '2016-01-31T12:00:00Z')

# Count all products
Product.api_q(q: 'count')

# Get last updated_at
Product.api_q(q: 'last_updated_at')

```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/denmarkmeralpis/api_queries. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](https://github.com/denmarkmeralpis/api_queries/blob/master/LICENSE.txt).

## Donate

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=nujiandenmarkmeralpis@gmail.com&lc=US&item_name=For+Living&no_note=0&cn=&curency_code=USD&bn=PP-DonationsBF:btn_donateCC_LG.gif:NonHosted)