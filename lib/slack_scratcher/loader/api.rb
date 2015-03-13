require 'slack'

module SlackScratcher
  module Loader
    class Api
      include Enumerable

      WAIT_TIME = 15

      def initalize
        
      end

      def each(adapter)
        active_channels do |channel|
          wait
          from = adapter.time_of_channel_last_log(channel.name)
          to = 'now'
          yield channel_history(channel, from, to)
        end
      end

      private

      def channels
        result = Slack.channels_list['channels']
        fail SlackScratcher::Error::ApiError unless result['ok'] == true

        result.map { |ch| { id: ch['id'], name: ch['name'] } }
      end

      def active_channels
        result = Slack.channels_list['channels']
        fail SlackScratcher::Error::ApiError unless result['ok'] == true

        result.select { |ch| ch['is_archived'] == false }
          .map { |ch| { id: ch['id'], name: ch['name'] } }
      end

      def user_info(user_id)
        result = Slack.users_info(user: user_id)
        fail SlackScratcher::Error::ApiError unless result['ok'] == true

        result
      end

      def channel_history(channel, from, to = Time.now)
        attrs = {
          channel: channel,
          oldest: from.to_i,
          latest: to.to_i
        }

        result = Slack.channels_history(attrs)
        fail SlackScratcher::Error::ApiError unless result['ok'] == true

        result
      end

      def wait
        sleep WAIT_TIME
      end
    end
  end
end
