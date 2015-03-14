require 'oj'

module SlackScratcher
  module Loader
    # Loader class for importing slack log data from exported data.
    #
    # @since 0.0.1
    class File < SlackScratcher::Loader::Base
      # Initialize SlackScratcher::Loader::File object.
      #
      # @param [String] target_dir Directory which unarchived log data
      #
      # @example Create File loader obect
      #   target_dir = '~/tmp/my_slack-2015-03-16/'
      #   SlackScratcher::Loader::File.new target_dir
      #
      # @return [SlackScratcher::Loader::File] File loader object
      def initialize(target_dir)
        fail ArgumentError unless ::File.directory?(target_dir)

        @target = target_dir
        @users = users
        @channels = channels
      end

      # Iterate all log data which is parsed from log file in log directory
      #
      # @param [NilClass] _ Not use
      #
      # @example Iterate all logs for priniting contents
      #   loader.each { |data| puts data }
      #
      # return [Boolean] If there isn't any ploblem, it returns true
      def each(_ = nil)
        files.each do |file|
          yield parse_log_file(file), file
        end

        true
      end

      private

      # @private
      def get_channel_dir(path)
        ::File.dirname(path).split('/').last
      end

      # @private
      def users
        load "#{@target}/users.json", 'id'
      end

      # @private
      def channels
        load "#{@target}/channels.json", 'name'
      end

      # @private
      def load(target, index_column)
        fail SlackScratcher::Error::FileNotFound unless ::File.exist? target

        channels = Oj.load(::File.read(target))
        SlackScratcher::Helper.index_data channels, index_column
      end

      # @private
      def channel_info(log_file)
        name = get_channel_dir(log_file)
        { name: name, id: @channels[name]['id'] }
      end

      # @private
      def parse_log_file(log_file)
        channel = channel_info(log_file)
        logs = Oj.load(::File.read(log_file))
        SlackScratcher::Model::Chats.new(logs, channel, @users).refined_data
      end

      # @private
      def files
        channel_dirs.inject([]) do |arr, channel|
          arr + log_files(channel)
        end
      end

      # @private
      def channel_dirs
        Dir["#{@target}/*/"]
      end

      # @private
      def log_files(channel)
        Dir["#{channel}*.json"]
      end
    end
  end
end
