Merchant.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'id'
      string 'name'
      string 'mcc'
    end
    
    # FIXME TODO this spreadsheet needs to be populated
    import "a list of merchants and their Merchant Category Code",
           :url => 'http://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdElxWTd0ckpfVXJ6OVFxLUhwR0ZOVXc&hl=en&single=true&gid=0&output=csv' do
      key 'id'
      store 'name'
      store 'mcc'
    end
  end
end
