State.class_eval do
  data_miner do
    # state names, ansi codes, and postal abbreviations
    import 'the U.S. Census State ANSI Code file',
           :url => 'http://www.census.gov/geo/www/ansi/state.txt',
           :delimiter => '|' do
      key   'postal_abbreviation', :field_name => 'STUSAB'
      store 'fips_code', :field_name => 'STATE'
      store 'name', :field_name => 'STATE_NAME'
    end

    # census divisions
    import 'the U.S. Census Geographic Terms and Definitions',
           :url => 'http://www.census.gov/popest/geographic/codes02.csv',
           :skip => 9,
           :select => lambda { |row| row['FIPS CODE STATE'].to_s.strip != 'X' and row['FIPS CODE COUNTY'].to_s.strip == 'X'} do
      key   'fips_code', :field_name => 'FIPS CODE STATE'
      store 'census_division_number', :field_name => 'Division'
    end
    
    # PADD
    import 'a list of state Petroleum Administration for Defense Districts',
           :url => 'http://spreadsheets.google.com/pub?key=t5HM1KbaRngmTUbntg8JwPA&gid=0&output=csv' do
      key   'postal_abbreviation', :field_name => 'State'
      store 'petroleum_administration_for_defense_district_code', :field_name => 'Code'
    end
  end
end

