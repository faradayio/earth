MerchantCategory.class_eval do
  data_miner do
    schema :options => 'ENGINE=InnoDB default charset=utf8' do
      string 'mcc'
      string 'description'
    end
    
    # FIXME TODO this may change when we get an authoritative MCC list
    import "a list of Merchant Category codes",
           :url => 'http://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdEx2WGZpbTRLdzJub05VR3pyQThRMGc&hl=en&single=true&gid=0&output=csv' do
      key 'mcc'
      store 'description'
    end
  end
end
