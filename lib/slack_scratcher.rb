$LOAD_PATH.unshift File.dirname(__FILE__)

module SlackScratcher
  autoload :Model, 'slack_scratcher/model'
  autoload :Loader, 'slack_scratcher/loader'
  autoload :Adapter, 'slack_scratcher/adapter'
  autoload :Router, 'slack_scratcher/router'
  autoload :Error, 'slack_scratcher/error'
end
