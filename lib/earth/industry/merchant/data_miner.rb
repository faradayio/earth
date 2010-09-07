Merchant.class_eval do
  data_miner do
    Merchant.define_schema(self)
    
    import "merchant dictionary",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdElxWTd0ckpfVXJ6OVFxLUhwR0ZOVXc&hl=en&single=true&gid=0&output=csv' do
      key 'id'
      store 'name'
      store 'mcc'
    end
  end
end
