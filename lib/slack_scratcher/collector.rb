module SlackScratcher
  class Collector
    def initialize(loader, adapter)
      @loader = loader
      @adapter = adapter
    end

    def collect_loop
      loop do
        @loader.each(@adapter) do |data|
          @adapter.send data
        end
      end
    end
  end
end
