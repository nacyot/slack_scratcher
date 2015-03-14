module SlackScratcher
  module Error
    autoload :UserNotFoundError, 'slack_scratcher/error/user_not_found_error'
    autoload :SlackApiError, 'slack_scratcher/error/slack_api_error'
    autoload :FileNotFound, 'slack_scratcher/error/file_not_found'
    autoload :TokenNotSet, 'slack_scratcher/error/token_not_set'
  end
end
