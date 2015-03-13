require 'oj'

module SlackScratcher
  module Loader
    class File
      include Enumerable

      def initialize(target_dir)
        fail ArgumentError unless ::File.directory?(target_dir)

        @target = target_dir
        @users = load_users
        @channels = load_channels
      end

      def each
        files.each do |file|
          yield parse_log_file(file), file
        end

        true
      end

      private

      def get_channel_dir(path)
        ::File.dirname(path).split('/').last
      end

      def load_users
        target = "#{@target}/users.json"
        fail SlackScratcher::Error::FileNotFound unless ::File.exist? target

        users = Oj.load(::File.read(target))
        index_data users, 'id'
      end

      def load_channels
        target = "#{@target}/channels.json"
        fail SlackScratcher::Error::FileNotFound unless ::File.exist? target

        channels = Oj.load(::File.read(target))
        index_data channels, 'name'
      end

      def index_data(dataset, column)
        dataset.map { |data| { data[column] => data } }.inject({}, :merge)
      end

      def channel_info(log_file)
        name = get_channel_dir(log_file)
        { name: name, id: @channels[name]['id'] }
      end

      def parse_log_file(log_file)
        channel = channel_info(log_file)
        logs = Oj.load(::File.read(log_file))
        chats = SlackScratcher::Model::Chats.new(logs, channel, @users)

        chats.refined_data
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
