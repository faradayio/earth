NationalTransitDatabaseCompany.class_eval do
  data_miner do
    import "US transit companies from the National Transit Database",
           :url => "#{Earth::DATA_DIR}/rail/ntd_companies.csv" do
      key 'id', :field_name => 'trs_id'
      store 'name',          :nullify => true
      store 'acronym',       :nullify => true
      store 'zip_code_name', :nullify => true
      store 'duns_number',   :nullify => true
    end
  end
end
