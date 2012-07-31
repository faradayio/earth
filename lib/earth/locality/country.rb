require 'falls_back_on'

require 'earth/model'

require 'earth/locality/electricity_mix'
require 'earth/rail/rail_company'

class Country < ActiveRecord::Base
  data_miner do
    process "Ensure ElectricityMix is imported because it's like a belongs_to association" do
      ElectricityMix.run_data_miner!
    end
  end

  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "countries"
  (
     "iso_3166_code"                         CHARACTER VARYING(255) NOT NULL PRIMARY KEY, /* alpha-2 2-letter like GB */
     "iso_3166_numeric_code"                 INTEGER,                                     /* numeric like 826; aka UN M49 code */
     "iso_3166_alpha_3_code"                 CHARACTER VARYING(255),                      /* 3-letter like GBR */
     "name"                                  CHARACTER VARYING(255),
     "heating_degree_days"                   FLOAT,
     "heating_degree_days_units"             CHARACTER VARYING(255),
     "cooling_degree_days"                   FLOAT,
     "cooling_degree_days_units"             CHARACTER VARYING(255),
     "automobile_urbanity"                   FLOAT,                           /* float from 0 to 1 */
     "automobile_fuel_efficiency"            FLOAT,
     "automobile_fuel_efficiency_units"      CHARACTER VARYING(255),
     "automobile_city_speed"                 FLOAT,
     "automobile_city_speed_units"           CHARACTER VARYING(255),
     "automobile_highway_speed"              FLOAT,
     "automobile_highway_speed_units"        CHARACTER VARYING(255),
     "automobile_trip_distance"              FLOAT,
     "automobile_trip_distance_units"        CHARACTER VARYING(255),
     "electricity_emission_factor"           FLOAT,
     "electricity_emission_factor_units"     CHARACTER VARYING(255),
     "electricity_co2_emission_factor"       FLOAT,
     "electricity_co2_emission_factor_units" CHARACTER VARYING(255),
     "electricity_ch4_emission_factor"       FLOAT,
     "electricity_ch4_emission_factor_units" CHARACTER VARYING(255),
     "electricity_n2o_emission_factor"       FLOAT,
     "electricity_n2o_emission_factor_units" CHARACTER VARYING(255),
     "electricity_loss_factor"               FLOAT,
     "flight_route_inefficiency_factor"      FLOAT,
     "lodging_occupancy_rate"                FLOAT,
     "lodging_natural_gas_intensity"         FLOAT,
     "lodging_natural_gas_intensity_units"   CHARACTER VARYING(255),
     "lodging_fuel_oil_intensity"            FLOAT,
     "lodging_fuel_oil_intensity_units"      CHARACTER VARYING(255),
     "lodging_electricity_intensity"         FLOAT,
     "lodging_electricity_intensity_units"   CHARACTER VARYING(255),
     "lodging_district_heat_intensity"       FLOAT,
     "lodging_district_heat_intensity_units" CHARACTER VARYING(255),
     "rail_passengers"                       FLOAT,
     "rail_trip_distance"                    FLOAT,
     "rail_trip_distance_units"              CHARACTER VARYING(255),
     "rail_speed"                            FLOAT,
     "rail_speed_units"                      CHARACTER VARYING(255),
     "rail_trip_electricity_intensity"       FLOAT,
     "rail_trip_electricity_intensity_units" CHARACTER VARYING(255),
     "rail_trip_diesel_intensity"            FLOAT,
     "rail_trip_diesel_intensity_units"      CHARACTER VARYING(255),
     "rail_trip_co2_emission_factor"         FLOAT,
     "rail_trip_co2_emission_factor_units"   CHARACTER VARYING(255)
  );
EOS

  self.primary_key = "iso_3166_code"
  
  has_many :rail_companies,  :foreign_key => 'country_iso_3166_code' # used to calculate rail data
  has_one :electricity_mix, :foreign_key => 'country_iso_3166_code'
  
  def self.united_states
    find_by_iso_3166_code('US')
  end
  
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
                :electricity_mix => lambda { ElectricityMix.fallback },
                :electricity_emission_factor => 0.626089, # from ecometrica paper - FIXME TODO calculate this
                :electricity_emission_factor_units => 'kilograms_co2e_per_kilowatt_hour', # FIXME TODO derive this
                :electricity_co2_emission_factor => 0.623537, # from ecometrica paper - FIXME TODO calculate this
                :electricity_co2_emission_factor_units => 'kilograms_per_kilowatt_hour', # FIXME TODO derive this
                :electricity_ch4_emission_factor => 0.000208, # from ecometrica paper - FIXME TODO calculate this
                :electricity_ch4_emission_factor_units => 'kilograms_co2e_per_kilowatt_hour', # FIXME TODO derive this
                :electricity_n2o_emission_factor => 0.002344, # from ecometrica paper - FIXME TODO calculate this
                :electricity_n2o_emission_factor_units => 'kilograms_co2e_per_kilowatt_hour', # FIXME TODO derive this
                :electricity_loss_factor => 0.096, # from ecometrica paper - FIXME TODO calculate this
                :flight_route_inefficiency_factor => lambda { maximum(:flight_route_inefficiency_factor) }, # default to the largest inefficiency factor
                :lodging_occupancy_rate => lambda { united_states.lodging_occupancy_rate }, # for now assume US represents world
                :lodging_natural_gas_intensity => lambda { united_states.lodging_natural_gas_intensity }, # for now assume US represents world
                :lodging_natural_gas_intensity_units => lambda { united_states.lodging_natural_gas_intensity_units }, # for now assume US represents world
                :lodging_fuel_oil_intensity => lambda { united_states.lodging_fuel_oil_intensity }, # for now assume US represents world
                :lodging_fuel_oil_intensity_units => lambda { united_states.lodging_fuel_oil_intensity_units }, # for now assume US represents world
                :lodging_electricity_intensity => lambda { united_states.lodging_electricity_intensity }, # for now assume US represents world
                :lodging_electricity_intensity_units => lambda { united_states.lodging_electricity_intensity_units }, # for now assume US represents world
                :lodging_district_heat_intensity => lambda { united_states.lodging_district_heat_intensity }, # for now assume US represents world
                :lodging_district_heat_intensity_units => lambda { united_states.lodging_district_heat_intensity_units }, # for now assume US represents world
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
  
  warn_unless_size 249
  warn_if_nulls_except(
     /heating/,
     /cooling/,
     /automobile/,
     /electricity/,
     /flight/,
     /lodging/,
     /rail/
  )
end
