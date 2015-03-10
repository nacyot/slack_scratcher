module SlackScratcher
  module Model
    class Chats
      def initialize(data, users)
        @data = data
        @users = users
      end
      
      def refine
        @data.map{ |log| refine_data(log) }
      end
      
      private
      def refine_data(log)
        user = @users.data[log['user']]
        log['name'] = user['name']
        log['profile_image'] = user['profile']['image_32']
        log['text'] = refine_text(log['text'])
        log['datetime'] = Time.at(log['ts']).iso8601

        log
      end
      
      def refine_text(text)
        # TODO - 링크 처리
        # TODO - 맨션 처리
        text
      end
    end
  end
end
