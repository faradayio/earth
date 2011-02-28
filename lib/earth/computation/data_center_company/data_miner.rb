DataCenterCompany.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      float  'power_usage_effectiveness'
    end
    
    import "a list of data center companies and their power usage effectiveness",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdFlxZVZLai01WWJOOTFiaUd1blF6VkE&hl=en&gid=0&output=csv' do
      key   'name'
      store 'power_usage_effectiveness'
    end
    
    verify "Power usage effectiveness should be one or more" do
      DataCenterCompany.all.each do |company|
        unless company.power_usage_effectiveness >= 1.0
          raise "Invalid power usage effectiveness for DataCenterCompany #{company.name}: #{company.power_usage_effectiveness} (should be >= 1.0)"
        end
      end
    end
  end
end
