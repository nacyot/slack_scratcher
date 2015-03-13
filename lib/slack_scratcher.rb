$LOAD_PATH.unshift File.dirname(__FILE__)
require 'logger'

module SlackScratcher
  autoload :Model, 'slack_scratcher/model'
  autoload :Loader, 'slack_scratcher/loader'
  autoload :Adapter, 'slack_scratcher/adapter'
  autoload :Router, 'slack_scratcher/router'
  autoload :Collector, 'slack_scratcher/collector'
  autoload :Error, 'slack_scratcher/error'

  def self.logger
    @logger ||= ::Logger.new(STDOUT)
  end
end
