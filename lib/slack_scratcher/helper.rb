module SlackScratcher
  module Helper
    def self.index_data(dataset, column)
      dataset.map { |data| { data[column] => data } }.inject({}, :merge)
    end
  end
end

