IndustriesSectors.class_eval do
  data_miner do
    IndustriesSectors.define_schema(self)
    
    import "industries to sectors dictionary",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdDVjVWRJdmVrcEtNd0U5Z3NxdGRlN1E&hl=en&single=true&gid=0&output=csv' do
      key 'naics_code'
      store 'ratio'
      store 'io_code'
    end
  end
end
