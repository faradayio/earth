NationalTransitDatabaseMode.class_eval do
  data_miner do
    import "National Transit Database modes",
           :url => 'https://docs.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdGFTLVpMdFgwSTQzTTFuc2lIVUdfSHc&output=csv' do
      key 'code'
      store 'name',      :nullify => true
      store 'rail_mode', :nullify => true
    end
  end
end
