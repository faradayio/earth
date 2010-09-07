ProductLinesSectors.class_eval do
  data_miner do
    ProductLinesSectors.define_schema(self)
    
    import "product lines to sectors dictionary",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdHRwWXRWai0tQnpxb2RfNFN3ZXROY1E&hl=en&single=true&gid=0&output=csv' do
      key 'ps_code'
      store 'ps_code_meaning'
      store 'ratio'
      store 'io_code'
      store 'io_meaning'
    end
  end
end
