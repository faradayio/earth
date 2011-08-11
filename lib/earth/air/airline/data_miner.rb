Airline.class_eval do
  data_miner do
    import "a Brighter Planet-curated list of airlines and codes not included in our other sources",
           :url => 'https://spreadsheets.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdGJoaFpENXRqMEM2NW42am5tNURGU2c&output=csv' do
      key 'name'
      store 'bts_code',  :nullify => true
      store 'iata_code', :nullify => true
      store 'icao_code', :nullify => true
    end
  end
end
