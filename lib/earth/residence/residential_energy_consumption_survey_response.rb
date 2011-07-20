class ResidentialEnergyConsumptionSurveyResponse < ActiveRecord::Base
  set_primary_key :id
  set_table_name :recs_responses
  
  belongs_to :census_division,     :foreign_key => 'census_division_number'
  belongs_to :census_region,       :foreign_key => 'census_region_number'
  # what follows are entirely derived here
  belongs_to :residence_class
  belongs_to :urbanity
  belongs_to :dishwasher_use
  belongs_to :air_conditioner_use
  belongs_to :clothes_machine_use
  
  extend CohortScope
  self.minimum_cohort_size = 5
  SUBCOHORT_THRESHOLD = 5 # per Matt
  
  INPUT_CHARACTERISTICS = [
    :census_region,
    :heating_degree_days,
    :cooling_degree_days,
    :residence_class,
    :rooms,
    :bedrooms,
    :bathrooms,
    :floorspace,
    :residents,
    :urbanity,
    :construction_year,
    :ownership,
  ]
  
  # sabshere 9/20/10 sorted with sort -d -t "'" -k 2 ~/Desktop/parts.txt
  force_schema do
    integer  'id'
    string  'air_conditioner_use_id'
    float    'annual_energy_from_electricity_for_air_conditioners'
    string   'annual_energy_from_electricity_for_air_conditioners_units'
    float    'annual_energy_from_electricity_for_clothes_driers'
    string   'annual_energy_from_electricity_for_clothes_driers_units'
    float    'annual_energy_from_electricity_for_dishwashers'
    string   'annual_energy_from_electricity_for_dishwashers_units'
    float    'annual_energy_from_electricity_for_freezers'
    string   'annual_energy_from_electricity_for_freezers_units'
    float    'annual_energy_from_electricity_for_heating_space'
    string   'annual_energy_from_electricity_for_heating_space_units'
    float    'annual_energy_from_electricity_for_heating_water'
    string   'annual_energy_from_electricity_for_heating_water_units'
    float    'annual_energy_from_electricity_for_other_appliances'
    string   'annual_energy_from_electricity_for_other_appliances_units'
    float    'annual_energy_from_electricity_for_refrigerators'
    string   'annual_energy_from_electricity_for_refrigerators_units'
    float    'annual_energy_from_fuel_oil_for_appliances'
    string   'annual_energy_from_fuel_oil_for_appliances_units'
    float    'annual_energy_from_fuel_oil_for_heating_space'
    string   'annual_energy_from_fuel_oil_for_heating_space_units'
    float    'annual_energy_from_fuel_oil_for_heating_water'
    string   'annual_energy_from_fuel_oil_for_heating_water_units'
    float    'annual_energy_from_kerosene'
    string   'annual_energy_from_kerosene_units'
    float    'annual_energy_from_natural_gas_for_appliances'
    string   'annual_energy_from_natural_gas_for_appliances_units'
    float    'annual_energy_from_natural_gas_for_heating_space'
    string   'annual_energy_from_natural_gas_for_heating_space_units'
    float    'annual_energy_from_natural_gas_for_heating_water'
    string   'annual_energy_from_natural_gas_for_heating_water_units'
    float    'annual_energy_from_propane_for_appliances'
    string   'annual_energy_from_propane_for_appliances_units'
    float    'annual_energy_from_propane_for_heating_space'
    string   'annual_energy_from_propane_for_heating_space_units'
    float    'annual_energy_from_propane_for_heating_water'
    string   'annual_energy_from_propane_for_heating_water_units'
    float    'annual_energy_from_wood'
    string   'annual_energy_from_wood_units'
    boolean  'attached_1car_garage'
    boolean  'attached_2car_garage'
    boolean  'attached_3car_garage'
    float    'bathrooms'
    integer  'bedrooms'
    string   'census_division_name'
    integer  'census_division_number'
    string   'census_region_name'
    integer  'census_region_number'
    string   'central_ac_use'
    string   'clothes_dryer_use'
    string  'clothes_machine_use_id'
    string   'clothes_washer_use'
    string   'construction_period'
    date     'construction_year'
    integer  'cooling_degree_days'
    string   'cooling_degree_days_units'
    boolean  'detached_1car_garage'
    boolean  'detached_2car_garage'
    boolean  'detached_3car_garage'
    string   'dishwasher_use_id'
    integer  'efficient_lights_on_1_to_4_hours'
    integer  'efficient_lights_on_4_to_12_hours'
    integer  'efficient_lights_on_over_12_hours'
    float    'floorspace'
    string   'floorspace_units'
    integer  'freezer_count'    
    integer  'full_bathrooms'
    integer  'half_bathrooms'
    boolean  'heated_garage'
    integer  'heating_degree_days'
    string   'heating_degree_days_units'
    float    'lighting_efficiency'
    float    'lighting_use'
    string   'lighting_use_units'
    integer  'lights_on_1_to_4_hours'
    integer  'lights_on_4_to_12_hours'
    integer  'lights_on_over_12_hours'
    integer  'outdoor_all_night_gas_lights'
    integer  'outdoor_all_night_lights'
    boolean  'ownership'
    integer  'refrigerator_count'
    string   'residence_class_id'
    integer  'residents'
    float    'rooms'
    boolean  'thermostat_programmability'
    integer  'total_rooms'
    string   'urbanity_id'
    float    'weighting'
    string   'window_ac_use'
  end
end
