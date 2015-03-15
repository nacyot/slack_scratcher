require 'slack'

module SlackScratcher
  module Loader
    # Loader class for importing latest slack logs through Slack API
    #
    # @since 0.1
    class Api < SlackScratcher::Loader::Base
      # Initialize SlackScratcher::Loader::Api object.
      #
      # @see https://api.slack.com/web
      #
      # @param [String] token Slack API token. It also can be set by using
      #   ENV['SLACK_TOKEN']
      #
      # @example Create File loader obect
      #   token = '123456789'
      #   SlackScratcher::Loader::Api.new token
      #
      # @return [SlackScratcher::Loader::Api] Api loader object
      def initialize(token = nil, wait_time = 30)
        @wait_time = wait_time
        authenticate_slack token
      end

      # Iterate all log data which is parsed from Slack API.
      #
      # @param [SlackScratcher::Adapter::Base] adapter Datastore adapter
      #   for getting when to starting fetch log
      #
      # @example Iterate all logs for priniting contents
      #   loader.each { |data| puts data }
      #
      # return [Boolean] If there isn't any ploblem, it returns true
      def each(adapter)
        @users || set_users

        active_channels.each do |channel|
          from = adapter.timestamp_of_last_channel_log(channel[:name])
          yield parse_log(channel, from), channel
        end

        true
      end

      private

      # @private
      def set_users
        @users = users
        SlackScratcher.logger.info "* Users list refreshed"
      end

      # @private
      def check_users(logs)
        logs
          .select { |log| log.key? 'user' }
          .map { |log| log['user'] }
          .any? { |user| @users[user].nil? }
      end

      # @private
      def parse_log(channel, from)
        logs = channel_history(channel[:id], from)
        set_users if check_users(logs)
        SlackScratcher::Model::Chats.new(logs, channel, @users).refined_data
      end

      # @private
      def authenticate_slack(token)
        token ||= ENV['SLACK_TOKEN']
        fail SlackScratcher::Error::TokenNotSet unless token
        Slack.configure { |config| config.token = token }
      end

      # @private
      def channels
        response = validate_response(Slack.channels_list)
        index_channels response['channels']
      end

      # @private
      def active_channels
        wait

        response = validate_response(Slack.channels_list)
        index_channels filter_active_channels(response['channels'])
      end

      # @private
      def filter_active_channels(data)
        data.select { |channel| channel['is_archived'] == false }
      end

      # @private
      def index_channels(data)
        data.map { |channel| { id: channel['id'], name: channel['name'] } }
      end

      # @private
      def users
        wait

        user_list = validate_response(Slack.users_list, :members)
        SlackScratcher::Helper.index_data user_list, 'id'
      end

      # @private
      def channel_history(channel_id, from, to = Time.now)
        wait

        attrs = {
          channel: channel_id,
          oldest: from,
          latest: to,
          count: 1000
        }

        validate_response Slack.channels_history(attrs), :messages
      end

      # @private
      def validate_response(response, key = nil)
        fail SlackScratcher::Error::ApiError unless response['ok'] == true
        return response unless key
        response[key.to_s]
      end

      # @private
      def wait
        sleep @wait_time
      end
    end
  end
end
