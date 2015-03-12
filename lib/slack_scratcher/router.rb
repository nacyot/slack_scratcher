module SlackScratcher
  class Router
    def initialize(loader, adapter)
      @loader = loader
      @adapter = adapter
    end

    def route
      @loader.each do |data|
        @adapter.send data
      end
    end
  end
end
