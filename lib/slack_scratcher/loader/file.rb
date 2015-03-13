require 'oj'

module SlackScratcher
  module Loader
    class File
      include Enumerable

      def initialize(target_dir)
        fail ArgumentError unless ::File.directory?(target_dir)

        @target = target_dir
        @users = load_users
      end

      def each
        files.each do |file|
          yield parse_log_file(file)
        end
      end

      private

      def get_channel_dir(path)
        File.dirname(path).split('/').last
      end

      def load_users
        users = Oj.load(::File.read("#{@target}/users.json"))
        users.map { |data| { data['id'] => data } }.inject({}, :merge)
      end

      def parse_log_file(log_file)
        channel = get_channel_dir(log_file)
        logs = Oj.load(::File.read(log_file))
        SlackScratcher::Model::Chats.new(logs, @users, channel).refined_data
      end

      def files
        channels.inject([]) do |arr, channel|
          arr + log_files(channel)
        end
      end

      def channels
        Dir["#{@target}/*/"]
      end

      def log_files(channel)
        Dir["#{channel}*.json"]
      end
    end
  end
end
