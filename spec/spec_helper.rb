require 'slack_scratcher'
require 'coveralls'
require 'rspec/its'

Coveralls.wear!

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :expect }
end
