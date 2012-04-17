CensusRegion.class_eval do
  data_miner do
    import('the U.S. Census Geographic Terms and Definitions',
           :url => 'http://www.census.gov/popest/about/geo/state_geocodes_v2009.txt',
           :skip => 6,
           :headers => %w{ Region Division FIPS Name },
           :select => proc { |row| row['Region'].to_i > 0 and row['Division'].to_i == 0 }) do
      key   'number', :field_name => 'Region'
      store 'name', :field_name => 'Name'
    end
  end
end
