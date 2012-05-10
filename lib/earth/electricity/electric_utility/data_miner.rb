ElectricUtility.class_eval do
  data_miner do
    import 'EIA Form 861 records from 2010 (revised)',
           :url => 'http://www.eia.gov/Ftproot/pub/electricity/f86110.zip',
           :filename => 'file1_2010.xls',
           :skip => 7 do
      key   'eia_id', :field_name => 'UTILITY_ID'
      store 'name', :field_name => 'UTILITY_NAME'
      store 'state_postal_abbreviation', :field_name => 'MAIL_STATE'
      store 'nerc_abbreviation', :field_name => 'NERC_LOCATION'
    end
  end
end
