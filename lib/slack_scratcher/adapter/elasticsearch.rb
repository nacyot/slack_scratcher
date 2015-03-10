module SlackScratcher
  module Adapter
    class Elasticsearch
      def initialize(hosts)
        @client = Elasticsearch::Client.new hosts: hosts
      end

      def send(data)
        @client.bulk(data)
      end
    end
  end
end
