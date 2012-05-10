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

    import 'Green Button implementers (by name)',
           :url => 'http://greenbuttondata.org/greenadopt.html',
           :row_css => '#adopt+p+h2+table li.implemented',
           :headers => %w{name},
           :select => proc { |row| ElectricUtility.exists?(:name => row['name']) } do
      key 'name'
      store 'green_button_implementer', :static => true
    end

    import 'Green Button implementers (by alias)',
           :url => 'http://greenbuttondata.org/greenadopt.html',
           :row_css => '#adopt+p+h2+table li.implemented',
           :headers => %w{alias},
           :select => proc { |row| ElectricUtility.exists?(:alias => row['alias']) } do
      key 'alias'
      store 'green_button_implementer', :static => true
    end

    import 'Green Button committers (by name)',
           :url => 'http://greenbuttondata.org/greenadopt.html',
           :row_css => '#adopt+p+h2+table li.committed',
           :headers => %w{name},
           :select => proc { |row| ElectricUtility.exists?(:name => row['name']) } do
      key 'name'
      store 'green_button_committer', :static => true
    end

    import 'Green Button committers (by alias)',
           :url => 'http://greenbuttondata.org/greenadopt.html',
           :row_css => '#adopt+p+h2+table li.committed',
           :headers => %w{alias},
           :select => proc { |row| ElectricUtility.exists?(:alias => row['alias']) } do
      key 'alias'
      store 'green_button_committer', :static => true
    end
  end
end
