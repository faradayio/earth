AutomobileSizeClass.class_eval do
  data_miner do
    schema Earth.database_options do
      string   'name'
      float    'fuel_efficiency_city'
      string   'fuel_efficiency_city_units'
      float    'fuel_efficiency_highway'
      string   'fuel_efficiency_highway_units'
      float    'annual_distance'
      string   'annual_distance_units'
      string   'emblem'
      float    'hybrid_fuel_efficiency_city_multiplier'
      float    'hybrid_fuel_efficiency_highway_multiplier'
      float    'conventional_fuel_efficiency_city_multiplier'
      float    'conventional_fuel_efficiency_highway_multiplier'
    end

    import "a list of size classes and pre-calculated annual distances and fuel efficiencies",
           :url => 'http://static.brighterplanet.com/science/data/transport/automobiles/models_export/automobile_size_class.csv' do
      key 'name'
      store 'annual_distance', :units => :kilometres
      store 'fuel_efficiency_city', :units => :kilometres_per_litre
      store 'fuel_efficiency_highway', :units => :kilometres_per_litre
    end

    # Ian 5/27/2010 I'm pretty sure we don't need emblems in middleware
    # import "",
    #        :url => 'http://static.brighterplanet.com/science/data/transport/automobiles/models_export/automobile_size_class_emblems.csv' do
    #   key 'name'
    #   store 'emblem'
    # end
    
    import "pre-calculated hybridity multipliers",
           :url => 'http://static.brighterplanet.com/science/data/transport/automobiles/vehicle_classes/fuel_efficiency_multipliers.csv' do
      key 'name'
      store 'hybrid_fuel_efficiency_city_multiplier'
      store 'hybrid_fuel_efficiency_highway_multiplier'
      store 'conventional_fuel_efficiency_city_multiplier'
      store 'conventional_fuel_efficiency_highway_multiplier'
    end
  end
end

