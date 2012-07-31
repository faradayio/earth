ComputationCarrier.class_eval do
  data_miner do
    import "a list of computation carriers and their power usage effectiveness",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdFlxZVZLai01WWJOOTFiaUd1blF6VkE&gid=0&output=csv' do
      key   'name'
      store 'power_usage_effectiveness'
    end
  end
end
