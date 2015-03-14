require 'slack_scratcher'
require 'coveralls'
require 'factory_girl'

Coveralls.wear!

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :expect }
  config.include FactoryGirl::Syntax::Methods
end
