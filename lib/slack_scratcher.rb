$LOAD_PATH.unshift File.dirname(__FILE__)
require 'logger'
require 'dotenv'
require 'faraday'

Dotenv.load

# Importing slack logs from exported fils or API to elasticsearch or
# other detastores
#
# @since 0.0.1
module SlackScratcher
  autoload :Model, 'slack_scratcher/model'
  autoload :Loader, 'slack_scratcher/loader'
  autoload :Adapter, 'slack_scratcher/adapter'
  autoload :Router, 'slack_scratcher/router'
  autoload :Error, 'slack_scratcher/error'
  autoload :Helper, 'slack_scratcher/helper'

  # logger for SlackScratcher Library
  # @return [Logger] Ruby standard logger object
  def self.logger
    @logger ||= ::Logger.new(STDOUT)
  end
end
