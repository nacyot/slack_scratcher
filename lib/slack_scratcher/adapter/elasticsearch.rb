require 'elasticsearch'

module SlackScratcher
  module Adapter
    # Elasticsearch adapter for storing slack logs.
    #
    # @since 0.0.1
    # @attr_reader [Elasticsearch::Client] client elasticsearch client
    class Elasticsearch < SlackScratcher::Adapter::Base
      attr_reader :client

      # Initialize SlackScratcher::Adapter::Elasticsearch object.
      #
      # @param [Array] hosts array of Elasticsearch hosts
      # @param [Hash] metadata metadata for storing
      # @option metadata [string] :index index for storing
      # @option metadata [string] :type type for storing
      #
      # @example return Elasticsearch adapter object
      #   hosts = ['http://192.168.59.103:9200']
      #   metadata = {index: 'slack', type: 'log'}
      #   SlackScratcher::Adapter::Elastisearch.new(hosts, metadata)
      #
      # @return [SlackScratcher::Adapter::Elasticsearh]
      #   Elasticsearch adapter object
      def initialize(hosts, metadata = {})
        fail ArgumentError if !hosts.is_a?(Array) || !metadata.is_a?(Hash)
        fail ArgumentError if !metadata.key?(:index) || !metadata.key?(:type)

        @client = ::Elasticsearch::Client.new hosts: hosts
        @metadata = metadata
      end

      # store data into elastisearch host.
      #
      # @see http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Actions#bulk-instance_method
      # @param [Array] raw_data slack logs which parsed by loader
      #
      # @example Send log from loader to elastisearch adapter
      #   loader.each { |data| adapter.store data }
      #
      # @raise [Elasticsearch::Transport::Transport::Errors::BadRequest]
      #   It raise when request is fail
      #
      # @return [Hash] Deserialized Elasticsearch response
      # @return [Boolean] If raw_data is empty, it returns false
      def store(raw_data)
        data = format_bulk(raw_data)
        return client.bulk data unless raw_data.empty?
        false
      rescue ::Elasticsearch::Transport::Transport::Errors::BadRequest => error
        SlackScratcher.logger.error error
        false
      end

      # Create index and set mapping for saving slack log data
      #
      # @example Create index and set mapping
      #   adapter.ready_index
      #
      # @return [Boolean] If there isn't any problem, it returns true
      def ready_index
        unless index?
          create_index
          put_mapping
        end

        true
      end

      # Get last logs' timestamp of specific channel from saved data
      #
      # @param [String] channel_name channel name
      #
      # @example Get saved last log's timestamp of general channel
      #   adapter.timestamp_of_last_log 'general' #=> '1426337804.820065'
      #
      # @return [String] Timestamp of last log
      # @return [String] If there isn't saved log, it returns '0'
      def timestamp_of_last_channel_log(channel_name)
        request_body = create_body(query_for_last_log(channel_name))
        log = client.search request_body

        return '0' if log['hits']['total'] == 0
        log['hits']['hits'][0]['_source']['ts']
      end

      private

      # @private
      def index
        @metadata[:index]
      end

      # @private
      def type
        @metadata[:type]
      end

      # @private
      def index?
        client.indices.exists(index: index)
      end

      # @private
      def create_index
        client.indices.create(index: index)
      end

      # @private
      def put_mapping
        client.indices.put_mapping create_body(mapping)
      end

      # @private
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

      # @private
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

      # @private
      def create_body(body = {})
        {
          index: index,
          type: type,
          body: body
        }
      end

      # @private
      def format_bulk(data)
        { body: data.map { |log| format_log(log) } }
      end

      # @private
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
