module SlackScratcher
  module Error
    autoload :UserNotFoundError, 'slack_scratcher/error/user_not_found_error'
    autoload :SlackApiError, 'slack_scratcher/error/slack_api_error'
  end
end
