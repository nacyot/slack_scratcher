module SlackScratcher
  class Router
    def initialize(loader, adapter)
      @loader = loader
      @adapter = adapter
    end

    def route
      ready
      _route
    end

    def route_loop
      ready
      loop { _route }
    end

    private

    def ready
      @adapter.ready_index
    end

    def _rotue
      @loader.each(@adapter) do |data, metadata|
        @adapter.send data
        SlackScratcher.logger.info "* #{metadata} is routed."
      end      
    end
  end
end
