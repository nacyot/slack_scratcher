module SlackScratcher
  # SlackScratcher Loader namespace
  # @since 0.0.1
  module Loader
    autoload :Base, 'slack_scratcher/loader/base'
    autoload :File, 'slack_scratcher/loader/file'
    autoload :Api, 'slack_scratcher/loader/api'
  end
end
