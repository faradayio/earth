BtsAircraft.class_eval do
  data_miner do
    import "the BTS aircraft type lookup table",
           :url => "file://#{Earth::DATA_DIR}/air/bts_aircraft_types.csv",
           :errata => { :url => "file://#{Earth::ERRATA_DIR}/bts_aircraft/bts_errata.csv" } do
      key 'bts_code',      :field_name => 'Code'
      store 'description', :field_name => 'Description'
    end
  end
end
