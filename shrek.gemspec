
# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shrek/version'

Gem::Specification.new do |spec|
  spec.name          = 'shrek'
  spec.version       = Shrek::VERSION
  spec.authors       = ['Kvokka']
  spec.email         = ['kvokka@yahoo.com']

  spec.summary       = 'Nested code organizer.'
  spec.description   = 'Help to keep deeply nested code with similar structure'
  spec.homepage      = 'https://github.com/kvokka/shrek'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  raise 'RubyGems 2.0 or newer is required' unless spec.respond_to?(:metadata)
  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_development_dependency 'guard', '~> 2.14.0'
  spec.add_development_dependency 'guard-rspec', '~> 4.7.0'
  spec.add_development_dependency 'overcommit', '~> 0.44.0'
  spec.add_development_dependency 'pry', '~> 0.11.0'
  spec.add_development_dependency 'reek', '~> 4.8.0'
  spec.add_development_dependency 'rubocop', '~> 0.54.0'
end
