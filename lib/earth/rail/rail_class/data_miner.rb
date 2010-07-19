RailClass.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      float  'distance'
      string 'distance_units'
      float  'passengers'
      float  'speed'
      string 'speed_units'
      float  'duration'
      string 'duration_units'
      float  'electricity_intensity'
      string 'electricity_intensity_units'
      float  'diesel_intensity'
      string 'diesel_intensity_units'
      string 'description'
    end
    
    process "Define some unit conversions" do
      Conversions.register :gallons_per_mile, :litres_per_kilometre, 2.35214583
    end

    import "a list of rail classes and pre-calculated trip and fuel use characteristics",
           :url => 'http://static.brighterplanet.com/science/data/transport/rail/rail_classes.csv' do
      key   'name'
      store 'description'
      store 'distance', :from_units => :miles, :to_units => :kilometres
      store 'speed', :from_units => :miles, :to_units => :kilometres
      store 'duration'
      store 'passengers'
      store 'electricity_intensity', :field_name => 'electricity_per_vehicle_mile', :from_units => :miles, :to_units => :kilometres
      store 'diesel_intensity', :field_name => 'diesel_per_vehicle_mile', :from_units => :gallons_per_mile, :to_units => :litres_per_kilometre
    end
  end
end

