lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'api_queries/version'

Gem::Specification.new do |spec|
  spec.name          = 'api_queries'
  spec.version       = ApiQueries::VERSION
  spec.authors       = ['denmarkmeralpis']
  spec.email         = ['denmark@nueca.net']

  spec.summary       = 'This will wrap all the api methods in just a single call.'
  spec.description   = 'A lightweight rails plugin that is very useful for developers.'
  spec.homepage      = 'https://github.com/denmarkmeralpis/api_queries'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.' unless spec.respond_to?(:metadata)

  spec.metadata['allowed_push_host'] = 'https://rubygems.org/gems/api_queries'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency             'activerecord', '>= 4.2'
  spec.add_dependency             'will_paginate', '~> 3.1'
  spec.add_development_dependency 'activesupport', '~> 4.2'
  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
