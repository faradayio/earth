Country.class_eval do
  data_miner do
    # http://www.iso.org/iso/list-en1-semic-3.txt
    # http://unstats.un.org/unsd/methods/m49/m49alpha.htm
    import "OpenGeoCode.org's Country Codes to Country Names list",
           :url => 'http://opengeocode.org/download/countrynames.txt',
           :format => :delimited,
           :delimiter => ';',
           :headers => false,
           :skip => 22 do
      key 'iso_3166_code', :field_number => 0
      store 'iso_3166_alpha_3_code', :field_number => 1
      store 'iso_3166_numeric_code', :field_number => 2
      store 'name', :field_number => 5 # romanized version
    end
    
    # AUTOMOBILE
    import "automobile-related data for the US",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdDdZRm1tNjY0c2dYNG00bXJ3TXRqUVE&gid=0&output=csv' do
      key 'iso_3166_code'
      store 'automobile_urbanity'
      store 'automobile_city_speed',    :units_field_name => 'automobile_city_speed_units'
      store 'automobile_highway_speed', :units_field_name => 'automobile_highway_speed_units'
      store 'automobile_trip_distance', :units_field_name => 'automobile_trip_distance_units'
    end
    
    process "Ensure AutomobileTypeFuelYear is populated" do
      AutomobileTypeFuelYear.run_data_miner!
    end
    
    process "Derive US average automobile fuel efficiency from AutomobileTypeFuelYear" do
      fuel_years = AutomobileTypeFuelYear.where(:year => AutomobileTypeFuelYear.maximum(:year))
      where(:iso_3166_code => 'US').update_all(
        :automobile_fuel_efficiency => (fuel_years.sum(:total_travel).to_f / fuel_years.sum(:fuel_consumption)),
        :automobile_fuel_efficiency_units => (fuel_years.first.total_travel_units + '_per_' + fuel_years.first.fuel_consumption_units.singularize)
      )
    end
    
    process "Convert automobile city speed from miles per hour to kilometres per hour" do
      conversion_factor = 1.miles.to(:kilometres)
      where(:automobile_city_speed_units => 'miles_per_hour').update_all(%{
        automobile_city_speed = 1.0 * automobile_city_speed * #{conversion_factor},
        automobile_city_speed_units = 'kilometres_per_hour'
      })
    end
    
    process "Convert automobile highway speed from miles per hour to kilometres per hour" do
      conversion_factor = 1.miles.to(:kilometres)
      where(:automobile_highway_speed_units => 'miles_per_hour').update_all(%{
        automobile_highway_speed = 1.0 * automobile_highway_speed * #{conversion_factor},
        automobile_highway_speed_units = 'kilometres_per_hour'
      })
    end
    
    process "Convert automobile trip distance from miles to kilometres" do
      conversion_factor = 1.miles.to(:kilometres)
      where(:automobile_trip_distance_units => 'miles').update_all(%{
        automobile_trip_distance = 1.0 * automobile_trip_distance * #{conversion_factor},
        automobile_trip_distance_units = 'kilometres'
      })
    end
    
    # FLIGHT
    import "country-specific flight route inefficiency factors derived from Kettunen et al. (2005)",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdEJoRVBZaGhnUmlhX240VXE3X0F3WkE&output=csv' do
      key   'iso_3166_code'
      store 'flight_route_inefficiency_factor'
    end
    
    # RAIL
    process "Ensure RailCompany and RailFuel are populated" do
      RailCompany.run_data_miner!
      RailFuel.run_data_miner!
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
    
    process "Unit conversion for European rail diesel intensity" do
      diesel = RailFuel.find_by_name("diesel")
      where(:rail_trip_diesel_intensity_units => 'grams_per_passenger_kilometre').update_all(%{
        rail_trip_diesel_intensity = 1.0 * rail_trip_diesel_intensity / 1000.0 / #{diesel.density},
        rail_trip_diesel_intensity_units = 'litres_per_passenger_kilometre'
      })
    end
    
    process "Unit conversion for European rail co2 emission factor" do
      where(:rail_trip_co2_emission_factor_units => 'grams_per_passenger_kilometre').update_all(%{
        rail_trip_co2_emission_factor = 1.0 * rail_trip_co2_emission_factor / 1000.0,
        rail_trip_co2_emission_factor_units = 'kilograms_per_passenger_kilometre'
      })
    end
    
    process "Derive US rail fuel and emission data from RailCompany" do
      country = united_states
      country.rail_trip_electricity_intensity = country.rail_companies.weighted_average(:electricity_intensity, :weighted_by => :passengers)
      country.rail_trip_electricity_intensity_units = 'kilowatt_hours_per_passenger_kilometre'
      country.rail_trip_diesel_intensity = country.rail_companies.weighted_average(:diesel_intensity, :weighted_by => :passengers)
      country.rail_trip_diesel_intensity_units = 'litres_per_passenger_kilometre'
      country.rail_trip_co2_emission_factor = country.rail_companies.weighted_average(:co2_emission_factor, :weighted_by => :passengers)
      country.rail_trip_co2_emission_factor_units = 'kilograms_per_passenger_kilometre'
      country.save!
    end
  end
end
