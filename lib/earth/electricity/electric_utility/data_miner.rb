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

    import 'Aliases', :url => 'https://docs.google.com/spreadsheet/pub?key=0AtyCBJLCFHlwdEM5WjVxRjBKWVJRcTJ3c1BhUnlSVXc&single=true&gid=0&output=csv' do
      key 'eia_id', :field_name => 'utility_id'
      store 'alias'
    end

    import 'Green Button implementors', :url => 'http://greenbuttondata.org/greenadopt.html' do
      # CSS selector "#adopt+p+h2+table li.implemented" will get you the utilities that have implemented
      # The tricky thing is that, for each record from this page, we want to set green_button_implementer=true on ALL ElectricUtility records whose `name` or `alias` attributes match this text from the bullet
      # If a matching record can't be found, we should avoid saving a *new* record here, if that is possible
      store 'green_button_implementer', :static => true
    end

    import 'Green Button committers', :url => 'http://greenbuttondata.org/greenadopt.html' do
      # CSS selector "#adopt+p+h2+table li.committed" will get you the utilities that have committed
      # Same caveats as above
      store 'green_button_committer', :static => true
    end
  end
end
