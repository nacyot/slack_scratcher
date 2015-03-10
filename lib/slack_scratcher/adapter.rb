module SlackScratcher
  module Adapter
    autoload :Elasticsearch, 'slack_scratcher/adapter/elasticsearch'
    autoload :File, 'slack_scratcher/adapter/file'
  end
end
