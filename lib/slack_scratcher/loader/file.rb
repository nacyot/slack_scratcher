require 'oj'

module SlackScratcher
  module Loader
    class File
      include Enumerable

      def initialize(target_dir)
        raise ArgumentError unless ::File.directory?(target_dir)

        @target = target_dir
        @users = load_users
      end

      def each
        all_files.each do |file|
          chats = parse_log_file(file)
          yield chats
        end
      end

      private

      def load_users
        users = Oj.load(::File.read("#@{target}/users.json"))
        users.map { |data| { data['id'] => data } }.inject({}, :merge)
      end

      def parse_log_file(log_file)
          logs = Oj.load(::File.read(log_file))
        SlackScratcher::Model::Chats.new logs, @users
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
