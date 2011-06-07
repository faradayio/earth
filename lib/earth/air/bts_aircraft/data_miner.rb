BtsAircraft.class_eval do
  data_miner do
    import "the BTS aircraft type lookup table",
           :url => "http://www.transtats.bts.gov/Download_Lookup.asp?Lookup=L_AIRCRAFT_TYPE",
           :errata => { :url => 'https://spreadsheets.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdEZ2d3JQMzV5T1o1T3JmVlFyNUZxdEE&output=csv' } do
      key 'bts_code',      :field_name => 'Code'
      store 'description', :field_name => 'Description'
    end
  end
end
