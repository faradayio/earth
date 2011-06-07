Airline.class_eval do
  data_miner do
    import "a Brighter Planet-curated list of airlines",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdDhoVHZmSTlZcHBsRUtPR0dPd0prMkE&output=csv' do
      key 'name'
      store 'bts_code',  :nullify => true
      store 'iata_code',  :nullify => true
      store 'icao_code', :nullify => true
    end
  end
end
