require 'earth/model'

require 'earth/locality/census_division'
require 'earth/locality/census_region'
require 'earth/residence/air_conditioner_use'
require 'earth/residence/clothes_machine_use'
require 'earth/residence/dishwasher_use'
require 'earth/residence/residence_class'
require 'earth/residence/urbanity'

class ResidentialEnergyConsumptionSurveyResponse < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "recs_responses"
  (
     "id"                                                        INTEGER NOT NULL PRIMARY KEY,
     "air_conditioner_use_id"                                    CHARACTER VARYING(255),
     "annual_energy_from_electricity_for_air_conditioners"       FLOAT,
     "annual_energy_from_electricity_for_air_conditioners_units" CHARACTER VARYING( 255),
     "annual_energy_from_electricity_for_clothes_driers"         FLOAT,
     "annual_energy_from_electricity_for_clothes_driers_units"   CHARACTER VARYING(255),
     "annual_energy_from_electricity_for_dishwashers"            FLOAT,
     "annual_energy_from_electricity_for_dishwashers_units"      CHARACTER VARYING(255),
     "annual_energy_from_electricity_for_freezers"               FLOAT,
     "annual_energy_from_electricity_for_freezers_units"         CHARACTER VARYING(255),
     "annual_energy_from_electricity_for_heating_space"          FLOAT,
     "annual_energy_from_electricity_for_heating_space_units"    CHARACTER VARYING(255),
     "annual_energy_from_electricity_for_heating_water"          FLOAT,
     "annual_energy_from_electricity_for_heating_water_units"    CHARACTER VARYING(255),
     "annual_energy_from_electricity_for_other_appliances"       FLOAT,
     "annual_energy_from_electricity_for_other_appliances_units" CHARACTER VARYING( 255),
     "annual_energy_from_electricity_for_refrigerators"          FLOAT,
     "annual_energy_from_electricity_for_refrigerators_units"    CHARACTER VARYING(255),
     "annual_energy_from_fuel_oil_for_appliances"                FLOAT,
     "annual_energy_from_fuel_oil_for_appliances_units"          CHARACTER VARYING(255),
     "annual_energy_from_fuel_oil_for_heating_space"             FLOAT,
     "annual_energy_from_fuel_oil_for_heating_space_units"       CHARACTER VARYING(255),
     "annual_energy_from_fuel_oil_for_heating_water"             FLOAT,
     "annual_energy_from_fuel_oil_for_heating_water_units"       CHARACTER VARYING(255),
     "annual_energy_from_kerosene"                               FLOAT,
     "annual_energy_from_kerosene_units"                         CHARACTER VARYING(255),
     "annual_energy_from_natural_gas_for_appliances"             FLOAT,
     "annual_energy_from_natural_gas_for_appliances_units"       CHARACTER VARYING(255),
     "annual_energy_from_natural_gas_for_heating_space"          FLOAT,
     "annual_energy_from_natural_gas_for_heating_space_units"    CHARACTER VARYING(255),
     "annual_energy_from_natural_gas_for_heating_water"          FLOAT,
     "annual_energy_from_natural_gas_for_heating_water_units"    CHARACTER VARYING(255),
     "annual_energy_from_propane_for_appliances"                 FLOAT,
     "annual_energy_from_propane_for_appliances_units"           CHARACTER VARYING(255),
     "annual_energy_from_propane_for_heating_space"              FLOAT,
     "annual_energy_from_propane_for_heating_space_units"        CHARACTER VARYING(255),
     "annual_energy_from_propane_for_heating_water"              FLOAT,
     "annual_energy_from_propane_for_heating_water_units"        CHARACTER VARYING(255),
     "annual_energy_from_wood"                                   FLOAT,
     "annual_energy_from_wood_units"                             CHARACTER VARYING(255),
     "attached_1car_garage"                                      INTEGER,
     "attached_2car_garage"                                      INTEGER,
     "attached_3car_garage"                                      INTEGER,
     "bathrooms"                                                 FLOAT,
     "bedrooms"                                                  INTEGER,
     "census_division_name"                                      CHARACTER VARYING(255),
     "census_division_number"                                    INTEGER,
     "census_region_name"                                        CHARACTER VARYING(255),
     "census_region_number"                                      INTEGER,
     "central_ac_use"                                            CHARACTER VARYING(255),
     "clothes_dryer_use"                                         CHARACTER VARYING(255),
     "clothes_machine_use_id"                                    CHARACTER VARYING(255),
     "clothes_washer_use"                                        CHARACTER VARYING(255),
     "construction_period"                                       CHARACTER VARYING(255),
     "construction_year"                                         DATE,
     "cooling_degree_days"                                       INTEGER,
     "cooling_degree_days_units"                                 CHARACTER VARYING(255),
     "detached_1car_garage"                                      INTEGER,
     "detached_2car_garage"                                      INTEGER,
     "detached_3car_garage"                                      INTEGER,
     "dishwasher_use_id"                                         CHARACTER VARYING(255),
     "efficient_lights_on_1_to_4_hours"                          INTEGER,
     "efficient_lights_on_4_to_12_hours"                         INTEGER,
     "efficient_lights_on_over_12_hours"                         INTEGER,
     "floorspace"                                                FLOAT,
     "floorspace_units"                                          CHARACTER VARYING(255),
     "freezer_count"                                             INTEGER,
     "full_bathrooms"                                            INTEGER,
     "half_bathrooms"                                            INTEGER,
     "heated_garage"                                             INTEGER,
     "heating_degree_days"                                       INTEGER,
     "heating_degree_days_units"                                 CHARACTER VARYING(255),
     "lighting_efficiency"                                       FLOAT,
     "lighting_use"                                              FLOAT,
     "lighting_use_units"                                        CHARACTER VARYING(255),
     "lights_on_1_to_4_hours"                                    INTEGER,
     "lights_on_4_to_12_hours"                                   INTEGER,
     "lights_on_over_12_hours"                                   INTEGER,
     "outdoor_all_night_gas_lights"                              INTEGER,
     "outdoor_all_night_lights"                                  INTEGER,
     "ownership"                                                 BOOLEAN,
     "refrigerator_count"                                        INTEGER,
     "residence_class_id"                                        CHARACTER VARYING(255),
     "residents"                                                 INTEGER,
     "rooms"                                                     FLOAT,
     "thermostat_programmability"                                BOOLEAN,
     "total_rooms"                                               INTEGER,
     "urbanity_id"                                               CHARACTER VARYING(255),
     "weighting"                                                 FLOAT,
     "window_ac_use"                                             CHARACTER VARYING(255)
  );
EOS

  self.primary_key = "id"
  self.table_name = :recs_responses
  
  belongs_to :census_division,     :foreign_key => 'census_division_number'
  belongs_to :census_region,       :foreign_key => 'census_region_number'
  # what follows are entirely derived here
  belongs_to :residence_class
  belongs_to :urbanity
  belongs_to :dishwasher_use
  belongs_to :air_conditioner_use
  belongs_to :clothes_machine_use
  
  INPUT_CHARACTERISTICS = [
    :ownership,
    :construction_year,
    :urbanity,
    :residents,
    :floorspace,
    :bathrooms,
    :bedrooms,
    :rooms,
    :residence_class,
    :cooling_degree_days,
    :heating_degree_days,
    :census_region
  ]
  
  # sabshere 9/20/10 sorted with sort -d -t "'" -k 2 ~/Desktop/parts.txt

  warn_unless_size 4382
end
