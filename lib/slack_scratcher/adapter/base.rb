module SlackScratcher
  module Adapter
    # Abstract adapter class for storing slack logs
    # @since 0.1
    class Base
      # @ abstract
      def store
        fail NotImplementedError
      end

      # @ abstract
      def timestamp_of_last_channel_log
        fail NotImplementedError
      end

      # @ abstract
      def ready_index
        fail NotImplementedError
      end
    end
  end
end
