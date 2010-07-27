IndustriesSectors.class_eval do
  data_miner do
    schema :options => 'ENGINE=InnoDB default charset=utf8' do
      string 'row_hash'
      string 'naics_code'
      float  'ratio'
      string 'io_code'
    end
    
    # FIXME TODO this spreadsheet is incomplete and should be updated when we get info from Carnegie Mellon
    import "a dictionary relating industry sectors to Bureau of Economic Analysis input-output sectors",
           :url => 'http://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdDVjVWRJdmVrcEtNd0U5Z3NxdGRlN1E&hl=en&single=true&gid=0&output=csv' do
      key 'row_hash'
      store 'naics_code'
      store 'ratio'
      store 'io_code'
    end
  end
end
