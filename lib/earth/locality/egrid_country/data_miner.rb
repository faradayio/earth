EgridCountry.class_eval do
  data_miner do
    import "the US average grid loss factor derived eGRID 2007 data",
           :url => 'http://www.epa.gov/cleanenergy/documents/egridzips/eGRID2010V1_1_STIE_USGC.xls',
           :sheet => 'USGC',
           :skip => 5 do
      key 'name', :static => 'US'
      store 'generation',  :field_name => 'USTNGN07', :units => :gigawatt_hours
      store 'imports',     :field_name => 'USTNFI07', :units => :gigawatt_hours
      store 'consumption', :field_name => 'USTCON07', :units => :gigawatt_hours
    end
  end
end
