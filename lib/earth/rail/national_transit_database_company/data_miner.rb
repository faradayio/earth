require 'earth/locality/data_miner'
NationalTransitDatabaseCompany.class_eval do
  data_miner do
    import "US transit companies from the National Transit Database",
           :url => 'https://docs.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdHBTZC1GUzg5VEU4QW9NOUo3V1BJWUE&output=csv' do
      key 'id', :field_name => 'trs_id'
      store 'name',          :nullify => true
      store 'acronym',       :nullify => true
      store 'zip_code_name', :nullify => true
      store 'duns_number',   :nullify => true
    end
  end
end
