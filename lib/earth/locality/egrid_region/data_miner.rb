EgridRegion.class_eval do
  data_miner do
    schema Earth.database_options do
      string   'name'
      float    'loss_factor'
    end
    
    # NOTE: the following import uses an 18 Mb zip - don't know if two imports will cause it to be downloaded twice...
    # 
    # import "eGRID regions and loss factors derived from eGRID 2007 data",
    #        :url => 'http://www.epa.gov/cleanenergy/documents/egridzips/eGRID2007_Version1-1.zip',
    #        :filename => 'eGRID2007_Version1-1/eGRID2007V1_1_year0504_STIE_USGC.xls',
    #        :sheet => 'STIE05',
    #        :skip => 4,
    #        :select => lambda { |row| row['eGRID2007 2005 file State sequence number'].to_i.between?(1, 51) } do
    #   key   'name', :field_name => 'Grid region (E=Eastern grid, W=Western grid, AK=Alaska, HI=Hawaii, TX=Texas)'
    #   store 'loss_factor', :field_name => '2005 grid gross loss factor'
    # end
    # 
    # import "the US average grid loss factor derived eGRID 2007 data"
    #        :url => 'http://www.epa.gov/cleanenergy/documents/egridzips/eGRID2007_Version1-1.zip',
    #        :filename => 'eGRID2007_Version1-1/eGRID2007V1_1_year0504_STIE_USGC.xls',
    #        :sheet => 'USGC',
    #        :skip => 5 do
    #   key # the name should be 'US'
    #   store # store the result of (USTNGN05 + USTNFI05 - USTCON05) / USTNGN05
    # end
    
    import "eGRID regions and loss factors derived from eGRID 2007 data",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdHoydC1MdDY0YVZkRE5zN0huOUZYbnc&hl=en&single=true&gid=0&output=csv' do
      key 'name'
      store 'loss_factor'
    end
  end
end
