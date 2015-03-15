module SlackScratcher
  module Loader
    # Abstract loader class for importing slack log data
    # @since 0.1
    class Base
      include Enumerable

      # @ abstract
      def each
        fail NotImplementedError
      end
    end
  end
end
