module SlackScratcher
  module Model
    class Chats
      attr_reader :refined_data, :data

      def initialize(data, users)
        fail ArgumentError if !data.is_a?(Array) || !users.is_a?(Hash)

        @data = data
        @users = users
        @refined_data = refine
      end

      private

      def refine
        @data.map { |log| refine_data(log) }
      end

      def refine_data(log)
        user = find_user(log['user']) unless user

        log['name'] = user['name']
        log['profile_image'] = user['profile']['image_32']
        log['text'] = refine_text(log['text'])
        log['datetime'] = Time.at(log['ts'].to_f)
        log
      rescue SlackScratcher::Error::UserNotFoundError
        user = { 'user' => 'undefined' }
        user['profile'] = { 'image_32' => '' }
      end

      def refine_text(text)
        text = ":#{text.to_s}" if text.is_a?(Symbol)

        text
          .gsub(%r{<@([A-Z0-9]{3,10})>}) { '@' + @users[$1]['name'] }
          .gsub(%r{<(http(s)?://.*?)>}) { $1 }
      end

      def find_user(user)
        result = @users[user]

        fail SlackScratcher::Error::UserNotFoundError if result == nil
        result
      end
    end
  end
end
