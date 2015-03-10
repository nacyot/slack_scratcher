module SlackScratcher
  module Model
    class Users
      attr_reader :data

      def initialize(target)
        @target = target
        load_data
        create_index
      end

      private
      def load_data
        @data = Oj.load(File.read("#@target/users.json"))
      end

      def create_index
        @data.map{|data| {data['id'] => data}}.inject({}, :merge)
      end
    end
  end
end
