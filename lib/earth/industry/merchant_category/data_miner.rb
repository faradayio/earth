MerchantCategory.class_eval do
  data_miner do
    MerchantCategory.define_schema(self)
    
    import "merchant category dictionary",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdEx2WGZpbTRLdzJub05VR3pyQThRMGc&hl=en&single=true&gid=0&output=csv' do
      key 'mcc'
      store 'description'
    end
  end
end
