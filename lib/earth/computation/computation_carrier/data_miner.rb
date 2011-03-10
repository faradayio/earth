ComputationCarrier.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      float  'power_usage_effectiveness'
    end
    
    import "a list of computation carriers and their power usage effectiveness",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdFlxZVZLai01WWJOOTFiaUd1blF6VkE&gid=0&output=csv' do
      key   'name'
      store 'power_usage_effectiveness'
    end
    
    verify "Power usage effectiveness should be one or more" do
      ComputationCarrier.all.each do |carrier|
        unless carrier.power_usage_effectiveness >= 1.0
          raise "Invalid power usage effectiveness for ComputationCarrier #{carrier.name}: #{carrier.power_usage_effectiveness} (should be >= 1.0)"
        end
      end
    end
  end
end
