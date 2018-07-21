require 'bundler/setup'
require 'active_record'
require 'api_queries'
require 'date'
require 'mysql2'
require 'will_paginate'
require 'will_paginate/per_page'
require 'will_paginate/array'
require 'simplecov'
require 'simplecov-console'

SimpleCov.formatter = SimpleCov.formatter = SimpleCov::Formatter::Console
SimpleCov.start

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'
  config.expose_dsl_globally = true
  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

ActiveRecord::Base.default_timezone = :utc
