module SlackScratcher
  module Model
    autoload :Channels, 'slack_scratcher/model/channels'
    autoload :Users, 'slack_scratcher/model/users'
    autoload :Chats, 'slack_scratcher/model/chats'

    autoload :Channel, 'slack_scratcher/model/channel'
    autoload :User, 'slack_scratcher/model/user'
    autoload :Chat, 'slack_scratcher/model/chat'
  end
end
