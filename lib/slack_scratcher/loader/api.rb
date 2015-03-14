require 'slack'

module SlackScratcher
  module Loader
    class Api
      include Enumerable

      WAIT_TIME = 1

      def initialize(token = nil)
        authenticate_slack(token)
      end

      def each(adapter)
        @users || set_users

        active_channels.each do |channel|
          from = adapter.timestamp_of_last_channel_log(channel[:name])
          yield parse_log(channel, from), channel
        end

        true
      end

      private

      def set_users
        @users = users
        SlackScratcher.logger.info "* Users list refreshed"
      end

      def check_users(logs)
        logs
          .select { |log| log.key? 'user' }
          .map { |log| log['user'] }
          .any? { |user| @users[user].nil? }
      end

      def parse_log(channel, from)
        logs = channel_history(channel[:id], from)
        if check_users(logs)
          set_users
        end
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
        wait

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
        wait

        user_list = validate_response(Slack.users_list, :members)
        SlackScratcher::Helper.index_data user_list, 'id'
      end

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

      def validate_response(response, key = nil)
        fail SlackScratcher::Error::ApiError unless response['ok'] == true
        return response unless key
        response[key.to_s]
      end

      def wait
        sleep WAIT_TIME
      end
    end
  end
end
