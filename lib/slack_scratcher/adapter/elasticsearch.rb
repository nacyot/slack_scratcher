require 'elasticsearch'

module SlackScratcher
  module Adapter
    class Elasticsearch
      attr_reader :client

      def initialize(hosts, metadata)
        @client = ::Elasticsearch::Client.new hosts: hosts
        @metadata = metadata
      end

      def send(data)
        @client.bulk format_bulk(data)
      end

      private

      def format_bulk(data)
        { body: data.map { |log| format_log(log) } }
      end

      def format_log(log)
        { index:
             {
               _index: @metadata[:index],
               _type: @metadata[:type],
               data: log
             }
         }
      end
    end
  end
end
