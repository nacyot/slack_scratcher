module SlackScratcher
  # SlackScratcher Adapter namespace
  # @since 0.0.1
  module Adapter
    autoload :Base, 'slack_scratcher/adapter/base'
    autoload :File, 'slack_scratcher/adapter/file'
    autoload :Elasticsearch, 'slack_scratcher/adapter/elasticsearch'
  end
end
