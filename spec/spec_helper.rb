require 'slack_scratcher'
require 'coveralls'

Coveralls.wear!

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :expect }
end
