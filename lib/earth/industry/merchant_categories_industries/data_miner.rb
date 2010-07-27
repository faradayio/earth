MerchantCategoriesIndustries.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'row_hash'
      string 'mcc'
      float  'ratio'
      string 'naics_code'
    end
    
    # FIXME TODO this table needs to be populated
    import "a dictionary relating merchant categories to indusry sectors",
           :url => 'http://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdHpDbjNwTHBmY252V01CQ1lOUUVMU1E&hl=en&single=true&gid=0&output=csv' do
      key 'row_hash'
      store 'mcc'
      store 'ratio'
      store 'naics_code'
    end
  end
end
