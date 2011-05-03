BtsAircraft.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'bts_code'
      string 'description'
    end
    
    import "the BTS aircraft type lookup table",
           :url => "http://www.transtats.bts.gov/Download_Lookup.asp?Lookup=L_AIRCRAFT_TYPE",
           :errata => { :url => 'https://spreadsheets.google.com/spreadsheet/pub?hl=en&hl=en&key=0AoQJbWqPrREqdGd1TWFReV96TE9vTEJUNnp2ak1kUlE&output=csv' } do
      key 'bts_code',      :field_name => 'Code'
      store 'description', :field_name => 'Description'
    end
  end
end
