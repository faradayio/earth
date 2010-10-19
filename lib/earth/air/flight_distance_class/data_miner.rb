FlightDistanceClass.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      float  'distance'
      string 'distance_units'
    end
    
    import "a list of distance classes taken from the WRI business travel tool",
           :url => 'http://static.brighterplanet.com/science/data/transport/air/distance_classes/distance_classes.csv' do
      key   'name'
      store 'distance', :units_field_name => 'distance_units'
    end
  end
end
