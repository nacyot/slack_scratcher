module SlackScratcher
  # SlackScratcher helper module
  # @since 0.0.1
  module Helper
    # Index data for searching by specific column
    #
    # @param [Array<Hash>] dataset Dataset
    # @param [String] column column key for indexing
    #
    # @example Index name column
    #   data = [{name: 'foo', value: 10}, {name: 'bar', value: 20}]
    #   indexed_data = helper.index_data(data, :name)
    #   indexed_data['foo'][:value] == 10 #=> true
    #
    # @return [Hash] indexed hash
    def self.index_data(dataset, column)
      dataset.map { |data| { data[column] => data } }.inject({}, :merge)
    end
  end
end
