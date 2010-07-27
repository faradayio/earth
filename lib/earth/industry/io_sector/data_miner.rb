IoSector.class_eval do
  data_miner do
    schema :options => 'ENGINE=InnoDB default charset=utf8' do
      string 'io_code'
      string 'description'
    end
    
    # FIXME TODO this import doesn't work
    import "the Bureau of Economic Analysis' list of Input-Output sector codes",
           :url => 'http://www.bea.gov/industry/iotables/naics_code_listings_page2.cfm',
           :row_xpath => '//table/tr/td[2]/table/tr/th[7]/tr',
           :column_xpath => 'td',
           :headers => false do
      key 'io_code', :field_number => 4
      store 'description', :field_number => 5
    end
  end
end
