module SlackScratcher
  class Router
    def initialize(loader, adapter)
      @loader = loader
      @adapter = adapter
    end

    def route
      @adapter.ready_index

      @loader.each do |data, file|
        @adapter.send data
        SlackScratcher.logger.info "* #{file} is routed."
      end
    end
  end
end
