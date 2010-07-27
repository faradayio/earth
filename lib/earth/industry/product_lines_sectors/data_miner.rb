ProductLinesSectors.class_eval do
  data_miner do
    schema :options => 'ENGINE=InnoDB default charset=utf8' do
      string 'row_hash'
      string 'pscode'
      float  'ratio'
      string 'io_code'
    end
    
    # FIXME TODO this spreadsheet needs to be populated
    import "a dictionary relating product lines to Bureau of Economic Analysis input-output sectors",
           :url => 'http://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdHRwWXRWai0tQnpxb2RfNFN3ZXROY1E&hl=en&single=true&gid=0&output=csv' do
      store 'pscode'
      store 'ratio'
      store 'io_code'
    end
  end
end
