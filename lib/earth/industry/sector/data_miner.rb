Sector.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'io_code'
      string 'description'
      float  'emission_factor'
      string 'emission_factor_units'
    end
    
    # FIXME TODO this import doesn't work
    # import "the Bureau of Economic Analysis' list of Input-Output sector codes",
    #        :url => 'http://www.bea.gov/industry/iotables/naics_code_listings_page2.cfm',
    #        :row_xpath => '//table/tr/td[2]/table/tr/th[7]/tr',
    #        :column_xpath => 'td',
    #        :headers => false do
    #   key 'io_code', :field_number => 4
    #   store 'description', :field_number => 5
    # end
    
    import "emissions factors calculated from EIOLCA",
           :url => 'http://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdHV2dzdjdGVnLUJCdDA4TURXNThROVE&hl=en&single=true&gid=1&output=csv' do
      key 'io_code'
      store 'description' # take this out when fix above import
      store 'emission_factor', :units_field_name => 'emission_factor_units'
    end
  end
end
