module SlackScratcher
  module Model
    class Chats
      attr_reader :refined_data, :data

      def initialize(data, channel, users)
        if !data.is_a?(Array) || !users.is_a?(Hash) || !channel.is_a?(Hash)
          fail ArgumentError
        end

        @data = data
        @users = users
        @channel = channel

        @refined_data = refine
      end

      private

      def refine
        @data
          .map { |log| refine_data(log) }
          .select { |log| !log['uid'].nil? }
      end

      def refine_data(log)
        user = find_user(log) unless user

        log['username'] = user['name']
        log['profile_image'] = user['profile']['image_32']
        log['text'] = refine_text(log['text'])
        log['channel'] = @channel[:name]
        log['channel_id'] = @channel[:id]
        log['datetime'] = Time.at(log['ts'].to_f).iso8601

        log['uid'] = create_uid(log)

        log
      end

      def create_uid(log)
        "#{log['datetime']}-#{log['channel_id']}-#{log['username']}"
      end

      def refine_text(text)
        text = ":#{text}" if text.is_a?(Symbol)

        text
          .gsub(%r{<@([A-Z0-9]{3,10})>}) { '@' + @users[$1]['name'] }
          .gsub(%r{<(http(s)?://.*?)>}) { $1 }
      end

      def find_user(log)
        return bot_user(log) if log.key?('username')

        result = @users[log['user']]

        fail SlackScratcher::Error::UserNotFoundError if result.nil?
        result
      rescue SlackScratcher::Error::UserNotFoundError
        unknown_user
      end

      def undefined_user
        user = { 'name' => '_unknown_' }
        user['profile'] = { 'image_32' => '' }
        user
      end

      def bot_user(log)
        user = { 'name' => log['username'] }
        user['profile'] = { 'image_32' => log['icons']['image_48'] }
        user
      end
    end
  end
end
