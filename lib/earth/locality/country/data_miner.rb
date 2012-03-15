require 'earth/automobile/data_miner'
require 'earth/hospitality/data_miner'
require 'earth/rail/data_miner'

Country.class_eval do
  data_miner do
    # http://www.iso.org/iso/list-en1-semic-3.txt
    # http://unstats.un.org/unsd/methods/m49/m49alpha.htm
    import "OpenGeoCode.org's Country Codes to Country Names list",
           :url => 'http://opengeocode.org/download/countrynames.txt',
           :format => :delimited,
           :delimiter => '; ',
           :headers => false,
           :skip => 22 do
      key 'iso_3166_code', :field_number => 0
      store 'iso_3166_alpha_3_code', :field_number => 1
      store 'iso_3166_numeric_code', :field_number => 2
      store 'name', :field_number => 5 # romanized version with utf-8 characters
    end
    
    import "heating and cooling degree day data from WRI CAIT",
           :url => 'https://docs.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdDN4MkRTSWtWRjdfazhRdWllTkVSMkE&output=csv',
           :select => Proc.new { |record| record['country'] != 'European Union (27)' },
           :errata => { :url => 'https://docs.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdDNSMUtCV0h4cUF4UnBKZlNkczlNbFE&output=csv' } do
      key 'name', :field_name => 'country'
      store 'heating_degree_days', :units => :degrees_celsius
      store 'cooling_degree_days', :units => :degrees_celsius
    end
    
    process "set Montenegro's heating and cooling degree days to the same as Serbia's" do
      montenegro = Country.find 'ME'
      serbia = Country.find 'RS'
      montenegro.heating_degree_days = serbia.heating_degree_days
      montenegro.heating_degree_days_units = serbia.heating_degree_days_units
      montenegro.cooling_degree_days = serbia.cooling_degree_days
      montenegro.cooling_degree_days_units = serbia.cooling_degree_days_units
      montenegro.save!
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
    
    # ELECTRICITY
    process "Ensure GreehouseGas is populated" do
      GreenhouseGas.run_data_miner!
    end
    
    import "calculate national electricity emission factors from Brander et al. (2011)",
           :url => 'https://docs.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdDZmWHFjLVdBZGRBdGxVdDdqd1YtYWc&output=csv' do
      key 'iso_3166_code', :field_name => 'country_iso_3166_code'
      store 'electricity_emission_factor', :synthesize => lambda { |row|
        (
          row['electricity_co2_emission_factor'].to_f +
          (row['electricity_ch4_emission_factor'].to_f * GreenhouseGas[:ch4].global_warming_potential) +
          (row['electricity_n2o_emission_factor'].to_f * GreenhouseGas[:n2o].global_warming_potential)
        ) }, :units => 'kilograms_co2e_per_kilowatt_hour'
      store 'electricity_loss_factor', :field_name => 'loss_factor'
    end
    
    process "Ensure EgridSubregion and EgridRegion are populated" do
      EgridSubregion.run_data_miner!
      EgridRegion.run_data_miner!
    end
    
    process "Derive average US electricity emission factor and loss factor from eGRID" do
      us = united_states
      us.electricity_emission_factor = EgridSubregion.fallback.electricity_emission_factor
      us.electricity_emission_factor_units = EgridSubregion.fallback.electricity_emission_factor_units
      us.electricity_loss_factor = EgridRegion.fallback.loss_factor
      us.save!
    end
    
    # FLIGHT
    import "country-specific flight route inefficiency factors derived from Kettunen et al. (2005)",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdEJoRVBZaGhnUmlhX240VXE3X0F3WkE&output=csv' do
      key   'iso_3166_code'
      store 'flight_route_inefficiency_factor'
    end
    
    # HOSPITALITY
    process "Define US average lodging occupancy rate" do
      country = united_states
      country.lodging_occupancy_rate = 0.601 # per http://www.pwc.com/us/en/press-releases/2012/pwc-us-lodging-industry-forecast.jhtml
      country.save!
    end
    
    process "Ensure CountryLodgingClass is populated" do
      CountryLodgingClass.run_data_miner!
    end
    
    process "Derive average hotel characteristics from CountryLodgingClass" do
      find_each do |country|
        if country.lodging_classes.any?
          country.lodging_natural_gas_intensity = country.lodging_classes.weighted_average(:natural_gas_intensity)
          country.lodging_natural_gas_intensity_units = 'cubic_metres_per_occupied_room_night' # FIXME TODO derive this
          country.lodging_fuel_oil_intensity = country.lodging_classes.weighted_average(:fuel_oil_intensity)
          country.lodging_fuel_oil_intensity_units = 'gallons_per_occupied_room_night' # FIXME TODO derive this
          country.lodging_electricity_intensity = country.lodging_classes.weighted_average(:electricity_intensity)
          country.lodging_electricity_intensity_units = 'kilowatt_hours_per_occupied_room_night' # FIXME TODO derive this
          country.lodging_district_heat_intensity = country.lodging_classes.weighted_average(:district_heat_intensity)
          country.lodging_district_heat_intensity_units = 'megajoules_per_occupied_room_night' # FIXME TODO derive this
          country.save!
        end
      end
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
