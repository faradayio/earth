BtsAircraft.class_eval do
  data_miner do
    import "the BTS aircraft type lookup table",
           :url => "http://www.transtats.bts.gov/Download_Lookup.asp?Lookup=L_AIRCRAFT_TYPE",
           :errata => { :url => "file://#{Earth.errata_dir}/bts_aircraft/bts_errata.csv" } do
      key 'bts_code',      :field_name => 'Code'
      store 'description', :field_name => 'Description'
    end
  end
end
