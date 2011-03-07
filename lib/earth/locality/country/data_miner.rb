Country.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'iso_3166_code'
      string 'name'
      float  'automobile_urbanity'
      float  'automobile_fuel_efficiency'
      string 'automobile_fuel_efficiency_units'
      float  'automobile_city_speed'
      string 'automobile_city_speed_units'
      float  'automobile_highway_speed'
      string 'automobile_highway_speed_units'
      float  'automobile_trip_distance'
      string 'automobile_trip_distance_units'
      float  'flight_route_inefficiency_factor'
    end
    
    import 'the official ISO country list',
           :url => 'http://www.iso.org/iso/list-en1-semic-3.txt',
           :skip => 2,
           :headers => false,
           :delimiter => ';',
           :encoding => 'ISO-8859-1' do
      key   'iso_3166_code', :field_number => 1
      store 'name', :field_number => 0
    end
    
    import "country-specific flight route inefficiency factors derived from Kettunen et al. (2005)",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdEJoRVBZaGhnUmlhX240VXE3X0F3WkE&gid=0&output=csv' do
      key   'iso_3166_code'
      store 'flight_route_inefficiency_factor'
    end
    
    import "automobile trip fallbacks",
           :url => 'https://spreadsheets.google.com/pub?hl=en&hl=en&key=0AoQJbWqPrREqdDdZRm1tNjY0c2dYNG00bXJ3TXRqUVE&gid=0&output=csv' do
      key 'iso_3166_code'
      store 'automobile_urbanity'
      store 'automobile_city_speed', :units_field_name => 'automobile_city_speed_units'
      store 'automobile_highway_speed', :units_field_name => 'automobile_highway_speed_units'
      store 'automobile_trip_distance', :units_field_name => 'automobile_trip_distance_units'
    end
    
    # FIXME TODO eventually need to do this for all countries
    process "Derive US average automobile fuel efficiency from AutomobileTypeFuelYear" do
      # AutomobileTypeFuelYear.run_data_miner!
      
      scope = AutomobileTypeFuelYear.where(:year => AutomobileTypeFuelYear.maximum(:year))
      fe = scope.sum(:total_travel) / scope.sum(:fuel_consumption)
      units = scope.first.total_travel_units + '_per_' + scope.first.fuel_consumption_units.singularize
      
      connection.execute %{
        UPDATE countries
        SET automobile_fuel_efficiency = #{fe},
            automobile_fuel_efficiency_units = '#{units}'
        WHERE iso_3166_code = 'US'
      }
    end
    
    process "Convert automobile city speed from miles per hour to kilometres per hour" do
      conversion_factor = 1.miles.to(:kilometres)
      connection.execute %{
        UPDATE countries
        SET automobile_city_speed = automobile_city_speed * #{conversion_factor},
            automobile_city_speed_units = 'kilometres_per_hour'
        WHERE automobile_city_speed_units = 'miles_per_hour'
      }
    end
    
    process "Convert automobile highway speed from miles per hour to kilometres per hour" do
      conversion_factor = 1.miles.to(:kilometres)
      connection.execute %{
        UPDATE countries
        SET automobile_highway_speed = automobile_highway_speed * #{conversion_factor},
            automobile_highway_speed_units = 'kilometres_per_hour'
        WHERE automobile_highway_speed_units = 'miles_per_hour'
      }
    end
    
    process "Convert automobile trip distance from miles to kilometres" do
      conversion_factor = 1.miles.to(:kilometres)
      connection.execute %{
        UPDATE countries
        SET automobile_trip_distance = automobile_trip_distance * #{conversion_factor},
            automobile_trip_distance_units = 'kilometres'
        WHERE automobile_trip_distance_units = 'miles'
      }
    end
    
    # FIXME TODO verify this
  end
end
