NationalTransitDatabaseMode.class_eval do
  data_miner do
    import "National Transit Database modes",
           :url => "#{Earth::DATA_DIR}/rail/ntd_modes.csv" do
      key 'code'
      store 'name',      :nullify => true
      store 'rail_mode', :nullify => true
    end
  end
end
