ClimateDivision.class_eval do
  data_miner do
    import "a list of climate divisions and their average heating and cooling degree days",
           :url => 'http://static.brighterplanet.com/science/data/climate/climate_divisions/climate_divisions.csv' do
      key 'name'
      store 'heating_degree_days', :from_units => :degrees_fahrenheit, :to_units => :degrees_celsius
      store 'cooling_degree_days', :from_units => :degrees_fahrenheit, :to_units => :degrees_celsius
      store 'state_postal_abbreviation'
    end
  end
end
