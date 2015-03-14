require 'slack'

module SlackScratcher
  module Loader
    class Api
      include Enumerable

      WAIT_TIME = 5

      def initialize(token = nil)
        authenticate_slack(token)
        @users = users
      end

      def each(adapter)
        active_channels do |channel|
          wait
          from = adapter.timestamp_of_last_channel_log(channel.name)

          yield parse_log(channel['id'], from), [channel['name'], from, to]
        end
      end

      def parse_log(channel, from)
        logs = channel_history(channel_id, from, to)
        fail SlackScratcher::Error::ApiError unless logs.key? 'messages'
        SlackScratcher::Model::Chats.new(logs, channel, @users).refined_data
      end

      def authenticate_slack(token)
        token ||= ENV['SLACK_TOKEN']
        fail SlackScratcher::Error::TokenNotSet unless token
        Slack.configure { |config| config.token = token }
      end

      def channels
        response = validate_response(Slack.channels_list)
        index_channels response['channels']
      end

      def active_channels
        response = validate_response(Slack.channels_list)
        index_channels filter_active_channels(response['channels'])
      end

      def filter_active_channels(data)
        data.select { |channel| channel['is_archived'] == false }
      end

      def index_channels(data)
        data.map { |channel| { id: channel['id'], name: channel['name'] } }
      end

      def users
        validate_response Slack.users_list
      end

      def user_info(user_id)
        validate_response Slack.users_info(user: user_id)
      end

      def channel_history(channel_id, from, to = Time.now)
        attrs = {
          channel: channel_id,
          oldest: from.to_i,
          latest: to.to_i,
          count: 1000
        }

        validate_response Slack.channels_history(attrs)
      end

      def validate_response(response)
        puts response
        fail SlackScratcher::Error::ApiError unless response['ok'] == true
        response
      end

      def wait
        sleep WAIT_TIME
      end
    end
  end
end
