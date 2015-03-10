require 'oj'

module SlackScratcher
  module Loader
    class File
      include Enumerable
      
      def initialize(target)
        @target = target
        @users = SlackScratcher::Model::Users.new(target)
      end

      def each
        all_files.each do |file|
          chats = parse_log_file(file), @users
          yield chats
        end
      end
      
      private
      def parse_log_file(log_file)
        logs = Oj.load(File.read(log_file))
        SlackScratcher::Model::Chats.new logs
      end

      def all_files
        list_channels.inject([]) do |arr, channel|
          arr + list_log_files(channel)
        end
      end
      
      def list_channels
        Dir["#{@target}/*/"]
      end

      def list_log_files(channel)
        Dir["#{@target}/#{channel}/*.json"]
      end
    end
  end
end
