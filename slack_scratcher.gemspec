$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'slack_scratcher/version'

Gem::Specification.new do |spec|
  # Project
  spec.name        = 'slack_scratcher'
  spec.version     = SlackScratcher::VERSION
  spec.licenses    = ['MIT']
  spec.platform    = Gem::Platform::RUBY
  spec.homepage    = 'http://slack-scratcher.nacyot.com'
  spec.summary     = 'Route your slack exporting data to elasticsearch.'
  spec.description = 'Route your slack exporting data to elasticsearch.'

  # Requirement
  spec.required_ruby_version = '>= 2.0.0'

  # Author
  spec.authors     = ['Daekwon Kim']
  spec.email       = ['propellerheaven@gmail.com']

  # Files
  all_files = `git ls-files -z`.split("\x0")
  spec.files = all_files.grep(%r{^(bin|lib)/})
  spec.executables = all_files.grep(%r{^bin/}){ |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Dependency
  spec.add_dependency('elasticsearch', '~> 1')

  # Development Dependency
  spec.add_development_dependency('guard')
  spec.add_development_dependency('guard-rspec')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('coveralls')
  spec.add_development_dependency('rubocop')
end
