Airline.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      string 'bts_code'
      string 'icao_code'
    end
    
    import "a Brighter Planet-curated list of airlines",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdDhoVHZmSTlZcHBsRUtPR0dPd0prMkE&output=csv',
           :encoding => 'UTF-8' do
      key 'name'
      store 'bts_code',  :nullify => true
      store 'icao_code', :nullify => true
    end
  end
end
