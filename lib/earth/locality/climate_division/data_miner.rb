ClimateDivision.class_eval do
  data_miner do
    import "a list of climate divisions and their average heating and cooling degree days",
           :url => 'http://static.brighterplanet.com/science/data/climate/climate_divisions/climate_divisions.csv' do
      key 'name'
      store 'heating_degree_days'
      store 'cooling_degree_days'
      store 'state_postal_abbreviation'
    end
    #associate :state, :key => :state_postal_abbreviation, :foreign_key => :postal_abbreviation
  end
end
