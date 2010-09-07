MerchantCategoriesIndustries.class_eval do
  data_miner do
    MerchantCategoriesIndustries.define_schema(self)
    
    import "merchant categories to industries dictionary",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdHpDbjNwTHBmY252V01CQ1lOUUVMU1E&hl=en&single=true&gid=0&output=csv' do
      key 'naics_code'
      store 'mcc'
      store 'ratio'
    end
  end
end
