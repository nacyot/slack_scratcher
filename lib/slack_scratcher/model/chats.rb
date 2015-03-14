module SlackScratcher
  module Model
    # Chats model for processing chat data
    #
    # @since 0.0.1
    # @attr_reader [Array] data Original data
    # @attr_reader [Array] refined_data data which is processed
    class Chats
      attr_reader :data, :refined_data

      # Initialize SlackScratcher::Model::Chats object. This class is
      # used in Loaders
      #
      # @see SlackScratcher::Loader::File
      # @see SlackScratcher::Loader::Api
      #
      # @param [Array] Data chatting data from loader
      # @param [Hash] channel Hash which have Channel informaiton
      # @option channel [string] :id Channel's unique id
      # @option channel [string] :name Channel's name
      # @param [Hash] users Information of all user
      #
      # @return [SlackScratcher::Model::Chats] Chats model object
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

      # @private
      def refine
        @data
          .map { |log| refine_data(log) }
          .select { |log| !log['uid'].nil? }
      end

      # @private
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

      # @private
      def create_uid(log)
        "#{log['datetime']}-#{log['channel_id']}-#{log['username']}"
      end

      # @private
      def refine_text(text)
        text = ":#{text}" if text.is_a?(Symbol)

        text
          .gsub(%r{<@([A-Z0-9]{3,10})>}) { '@' + @users[$1]['name'] }
          .gsub(%r{<(http(s)?://.*?)>}) { $1 }
      end

      # @private
      def find_user(log)
        return bot_user(log) if log.key?('username')

        result = @users[log['user']]

        fail SlackScratcher::Error::UserNotFoundError if result.nil?
        result
      rescue SlackScratcher::Error::UserNotFoundError
        unknown_user
      end

      # @private
      def undefined_user
        user = { 'name' => '_unknown_' }
        user['profile'] = { 'image_32' => '' }
        user
      end

      # @private
      def bot_user(log)
        user = { 'name' => log['username'] }
        user['profile'] = { 'image_32' => log['icons']['image_48'] }
        user
      end
    end
  end
end
