require 'slack_scratcher'
require 'coveralls'
require 'rspec/its'
require 'simplecov'
require 'simplecov-rcov'

Coveralls.wear!
SimpleCov.start
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :expect }
end
