Sector.class_eval do
  data_miner do
    Sector.define_schema(self)
    
    import "sectors dictionary",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdHV2dzdjdGVnLUJCdDA4TURXNThROVE&hl=en&single=true&gid=1&output=csv' do
      key 'io_code'
      store 'description'
      store 'emission_factor'
      store 'emission_factor_units'
    end
  end
end
