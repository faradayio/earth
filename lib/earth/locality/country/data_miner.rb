Country.class_eval do
  data_miner do
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
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdEJoRVBZaGhnUmlhX240VXE3X0F3WkE&output=csv' do
      key   'iso_3166_code'
      store 'flight_route_inefficiency_factor'
    end
    
    import "automobile-related data for the US",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdDdZRm1tNjY0c2dYNG00bXJ3TXRqUVE&gid=0&output=csv' do
      key 'iso_3166_code'
      store 'automobile_urbanity'
      store 'automobile_city_speed', :units_field_name => 'automobile_city_speed_units'
      store 'automobile_highway_speed', :units_field_name => 'automobile_highway_speed_units'
      store 'automobile_trip_distance', :units_field_name => 'automobile_trip_distance_units'
    end
    
    process "Ensure AutomobileTypeFuelYear is populated" do
      AutomobileTypeFuelYear.run_data_miner!
    end
    
    # FIXME TODO eventually need to do this for all countries
    process "Derive US average automobile fuel efficiency from AutomobileTypeFuelYear" do
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
    
    process "Ensure RailCompany is populated" do
      RailCompany.run_data_miner!
    end
    
    process "Calculate rail passengers, trip distance, and speed from RailCompany" do
      find_each do |country|
        if country.rail_companies.any?
          country.rail_passengers = country.rail_companies.sum(:passengers)
          country.rail_trip_distance = country.rail_companies.weighted_average(:trip_distance, :weighted_by => :passengers)
          country.rail_trip_distance_units = 'kilometres' if country.rail_trip_distance.present?
          country.rail_speed = country.rail_companies.weighted_average(:speed, :weighted_by => :passengers)
          country.rail_speed_units = 'kilometres_per_hour' if country.rail_speed.present?
          country.save!
        end
      end
    end
    
    import "european rail fuel and emission data derived from the UIC",
           :url => 'https://docs.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdDczWnlPN2VtX1RmU0EtOVBYRFo4REE&output=csv' do
      key 'iso_3166_code'
      store 'rail_trip_electricity_intensity', :units_field_name => 'rail_trip_electricity_intensity_units'
      store 'rail_trip_diesel_intensity',      :units_field_name => 'rail_trip_diesel_intensity_units'
      store 'rail_trip_co2_emission_factor',   :units_field_name => 'rail_trip_co2_emission_factor_units' 
    end
    
    process "Derive US rail fuel and emission data from RailCompany" do
      country = Country.united_states
      country.rail_trip_electricity_intensity = country.rail_companies.weighted_average(:electricity_intensity, :weighted_by => :passengers)
      country.rail_trip_electricity_intensity_units = 'kilowatt_hours_per_passenger_kilometre'
      country.rail_trip_diesel_intensity = country.rail_companies.weighted_average(:diesel_intensity, :weighted_by => :passengers)
      country.rail_trip_diesel_intensity_units = 'litres_per_passenger_kilometre'
      country.rail_trip_co2_emission_factor = country.rail_companies.weighted_average(:co2_emission_factor, :weighted_by => :passengers)
      country.rail_trip_co2_emission_factor_units = 'kilograms_per_passenger_kilometre'
      country.save!
    end
    
    # FIXME TODO verify this
  end
end
