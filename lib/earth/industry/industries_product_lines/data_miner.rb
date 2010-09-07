IndustriesProductLines.class_eval do
  data_miner do
    IndustriesProductLines.define_schema(self)
    
    import "sectors dictionary",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdHV2dzdjdGVnLUJCdDA4TURXNThROVE&hl=en&single=true&gid=1&output=csv' do
      key 'ps_code'
      store 'naics_code'
      store 'ratio'
      store 'revenue_allocated'
    end
  end
end
