require 'earth/electricity/green_button_adoption'

ElectricUtility.class_eval do
  data_miner do
    process "make sure green button adoption is populated" do
      GreenButtonAdoption.run_data_miner!
    end

    import 'EIA Form 861 records from 2010 (revised)',
           :url => 'http://www.eia.gov/Ftproot/pub/electricity/f86110.zip',
           :filename => 'file1_2010.xls',
           :skip => 7,
           :errata => { :url => "file://#{Earth::ERRATA_DIR}/electricity/electric_utility/eia_errata.csv" } do
      key   'eia_id',                    :field_name => 'UTILITY_ID'
      store 'name',                      :field_name => 'UTILITY_NAME'
      store 'state_postal_abbreviation', :field_name => 'MAIL_STATE',    :nullify => true
      store 'nerc_region_abbreviation',        :synthesize => proc { |row| (first_nerc = row['NERC_LOCATION'].match(/^(\w+)/))? first_nerc.captures[0] : nil }
      store 'second_nerc_region_abbreviation', :synthesize => proc { |row| (second_nerc = row['NERC_LOCATION'].match(/^\w+ ?[&,\/] ?(\w+)$/)) ? second_nerc.captures[0] : nil }
    end

    import 'Aliases', :url => 'https://docs.google.com/spreadsheet/pub?key=0AtyCBJLCFHlwdEM5WjVxRjBKWVJRcTJ3c1BhUnlSVXc&single=true&gid=0&output=csv' do
      key 'eia_id', :field_name => 'utility_id'
      store 'nickname', :field_name => 'alias'
    end
  end
end
