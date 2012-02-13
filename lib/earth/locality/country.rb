require 'earth/automobile'
require 'earth/hospitality'
require 'earth/rail'

class Country < ActiveRecord::Base
  self.primary_key = "iso_3166_code"
  
  has_many :rail_companies,  :foreign_key => 'country_iso_3166_code' # used to calculate rail data
  has_many :lodging_classes, :foreign_key => 'country_iso_3166_code', :class_name => 'CountryLodgingClass'
  
  falls_back_on :name => 'fallback',
                :automobile_urbanity => lambda { united_states.automobile_urbanity }, # for now assume US represents world
                :automobile_fuel_efficiency => ((22.5 + 16.2) / 2.0).miles_per_gallon.to(:kilometres_per_litre), # average of passenger car fuel unknown and light goods vehicle fuel unknown - WRI Mobile Combustion calculation tool v2.0
                :automobile_fuel_efficiency_units => 'kilometres_per_litre',
                :automobile_city_speed => lambda { united_states.automobile_city_speed }, # for now assume US represents world
                :automobile_city_speed_units => lambda { united_states.automobile_city_speed_units }, # for now assume US represents world
                :automobile_highway_speed => lambda { united_states.automobile_highway_speed }, # for now assume US represents world
                :automobile_highway_speed_units => lambda { united_states.automobile_highway_speed_units }, # for now assume US represents world
                :automobile_trip_distance => lambda { united_states.automobile_trip_distance }, # for now assume US represents world
                :automobile_trip_distance_units => lambda { united_states.automobile_trip_distance_units }, # for now assume US represents world
                :electricity_emission_factor => 0.69252, # from ecometrica paper - FIXME TODO calculate this
                :electricity_emission_factor_units => 'kilograms_co2e_per_kilowatt_hour', # FIXME TODO derive this
                :flight_route_inefficiency_factor => lambda { maximum(:flight_route_inefficiency_factor) }, # default to the largest inefficiency factor
                :lodging_occupancy_rate => lambda { united_states.lodging_occupancy_rate }, # for now assume US represents world
                :lodging_natural_gas_intensity => lambda { united_states.lodging_natural_gas_intensity }, # for now assume US represents world
                :lodging_natural_gas_intensity_units => lambda { united_states.lodging_natural_gas_intensity_units }, # for now assume US represents world
                :lodging_fuel_oil_intensity => lambda { united_states.lodging_fuel_oil_intensity }, # for now assume US represents world
                :lodging_fuel_oil_intensity_units => lambda { united_states.lodging_fuel_oil_intensity_units }, # for now assume US represents world
                :lodging_electricity_intensity => lambda { united_states.lodging_electricity_intensity }, # for now assume US represents world
                :lodging_electricity_intensity_units => lambda { united_states.lodging_electricity_intensity_units }, # for now assume US represents world
                :lodging_steam_intensity => lambda { united_states.lodging_steam_intensity }, # for now assume US represents world
                :lodging_steam_intensity_units => lambda { united_states.lodging_steam_intensity_units }, # for now assume US represents world
                :rail_trip_distance => lambda { weighted_average(:rail_trip_distance, :weighted_by => :rail_passengers) },
                :rail_trip_distance_units => 'kilometres', # FIXME TODO derive this
                :rail_speed => lambda { weighted_average(:rail_speed, :weighted_by => :rail_passengers) },
                :rail_speed_units => 'kilometres_per_hour', # FIXME TODO derive this
                :rail_trip_electricity_intensity => lambda { weighted_average(:rail_trip_electricity_intensity, :weighted_by => :rail_passengers) },
                :rail_trip_electricity_intensity_units => 'kilowatt_hour_per_passenger_kilometre', # FIXME TODO derive this
                :rail_trip_diesel_intensity => lambda { weighted_average(:rail_trip_diesel_intensity, :weighted_by => :rail_passengers) },
                :rail_trip_diesel_intensity_units => 'litres_per_passenger_kilometre', # FIXME TODO derive this
                :rail_trip_co2_emission_factor => lambda { weighted_average(:rail_trip_co2_emission_factor, :weighted_by => :rail_passengers) },
                :rail_trip_co2_emission_factor_units => 'kilograms_per_passenger_kilometre' # FIXME TODO derive this
  
  class << self
    def united_states
      find_by_iso_3166_code('US')
    end
  end
  
  col :iso_3166_code                            # alpha-2 2-letter like GB
  col :iso_3166_numeric_code, :type => :integer # numeric like 826; aka UN M49 code
  col :iso_3166_alpha_3_code                    # 3-letter like GBR
  col :name
  col :heating_degree_days, :type => :float
  col :heating_degree_days_units
  col :cooling_degree_days, :type => :float
  col :cooling_degree_days_units
  col :automobile_urbanity, :type => :float # float from 0 to 1
  col :automobile_fuel_efficiency, :type => :float
  col :automobile_fuel_efficiency_units
  col :automobile_city_speed, :type => :float
  col :automobile_city_speed_units
  col :automobile_highway_speed, :type => :float
  col :automobile_highway_speed_units
  col :automobile_trip_distance, :type => :float
  col :automobile_trip_distance_units
  col :electricity_emission_factor, :type => :float
  col :electricity_emission_factor_units
  col :flight_route_inefficiency_factor, :type => :float
  col :lodging_occupancy_rate, :type => :float
  col :lodging_natural_gas_intensity, :type => :float
  col :lodging_natural_gas_intensity_units
  col :lodging_fuel_oil_intensity, :type => :float
  col :lodging_fuel_oil_intensity_units
  col :lodging_electricity_intensity, :type => :float
  col :lodging_electricity_intensity_units
  col :lodging_steam_intensity, :type => :float
  col :lodging_steam_intensity_units
  col :rail_passengers, :type => :float
  col :rail_trip_distance, :type => :float
  col :rail_trip_distance_units
  col :rail_speed, :type => :float
  col :rail_speed_units
  col :rail_trip_electricity_intensity, :type => :float
  col :rail_trip_electricity_intensity_units
  col :rail_trip_diesel_intensity, :type => :float
  col :rail_trip_diesel_intensity_units
  col :rail_trip_co2_emission_factor, :type => :float
  col :rail_trip_co2_emission_factor_units
end
