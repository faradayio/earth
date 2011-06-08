CensusRegion.class_eval do
  data_miner do
    import 'the U.S. Census Geographic Terms and Definitions',
           :url => 'http://www.census.gov/popest/geographic/codes02.csv',
           :skip => 9,
           :select => lambda { |row| row['Region'].to_i > 0 and row['Division'].to_s.strip == 'X'} do
      key   'number', :field_name => 'Region'
      store 'name', :field_name => 'Name'
    end
  end
end

