require 'elasticsearch'

module SlackScratcher
  module Adapter
    class Elasticsearch
      attr_reader :client

      def initialize(hosts, metadata)
        @client = ::Elasticsearch::Client.new hosts: hosts
        @metadata = metadata
      end

      def send(raw_data)
        data = format_bulk(raw_data)
        @client.bulk data unless raw_data.empty?
      rescue ::Elasticsearch::Transport::Transport::Errors::BadRequest => error
        puts error
      end

      def timestamp_of_last_channel_log(channel_name)
        request_body = create_body(query_for_last_log(channel_name))
        log = @client.search request_body

        return 0 if log['hits']['total'] == 0
        log['hits']['hits'][0]['_source']['ts'].to_f
      end

      def ready_index
        unless index?
          create_index
          put_mapping
        end
      end

      private

      def index
        @metadata[:index]
      end

      def type
        @metadata[:type]
      end

      def index?
        @client.indices.exists(index: index)
      end

      def create_index
        @client.indices.create(index: index)
      end

      def put_mapping
        @client.indices.put_mapping create_body(mapping)
      end

      def mapping
        {
          type => {
            '_timestamp' => {
              'enabled' => true,
              'path' => 'dataetime'
            },
            '_id' => {
              'path' => 'uid'
            },
            '_routing' => {
              'required' => true,
              'path' => 'channel_id'
            }
          }
        }
      end

      def query_for_last_log(channel_name)
        {
          size: 1,
          sort:
            [ { datetime: { order: 'desc' } }],
          query: {
            match: {
              channel: channel_name
            }
          }
        }
      end

      def create_body(body = {})
        {
          index: index,
          type: type,
          body: body
        }
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
