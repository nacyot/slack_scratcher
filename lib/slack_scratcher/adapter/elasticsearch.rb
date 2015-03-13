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

      def timestamp_of_last_channel_log(channel_name)
        
      end

      def ready_index
        create_index unless has_index?
        put_timestamp_mapping unless has_timestamp_mapping?
      end

      private

      def index
        @metadata[:index]
      end

      def type
        @metadata[:type]
      end

      def has_index?
        @client.indices.exists(index: index)
      end

      def create_index
        @client.indices.create(index: index)
      end

      def has_timestamp_mapping?
        attrs = { index: index, type: type }

        mapping = @client.indices.get_mapping(attrs)
        return false unless mapping.has_key?('slack')
        log_mapping = mapping['slack']['mappings']['log']

        return false unless log_mapping.has_key?('_timestamp')
        return false unless log_mapping['_timestamp']['enabled'] == true

        true
      end

      def put_timestamp_mapping
        attrs = {
          index: index,
          type: type,
          body: timestamp_mapping
        }

        @client.indices.put_mapping(attrs)
      end

      def timestamp_mapping
        { type =>
          { '_timestamp' =>
            { 'enabled' => true, 'path' => 'dataetime' } } }
      end

      def format_bulk(data)
        { body: data.map { |log| format_log(log) } }
      end

      def format_log(log)
        { index:
             {
               _index: index,
               _type: type,
               data: log
             }
         }
      end
    end
  end
end
