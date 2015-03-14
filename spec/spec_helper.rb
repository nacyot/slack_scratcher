require 'slack_scratcher'
require 'coveralls'
require 'codeclimate-test-reporter'
require 'factory_girl'

Coveralls.wear!
CodeClimate::TestReporter.start

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :expect }
  config.include FactoryGirl::Syntax::Methods
end
