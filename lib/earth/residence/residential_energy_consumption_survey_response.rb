require 'earth/locality'
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
  col :id, :type => :integer
  col :air_conditioner_use_id
  col :annual_energy_from_electricity_for_air_conditioners, :type => :float
  col :annual_energy_from_electricity_for_air_conditioners_units
  col :annual_energy_from_electricity_for_clothes_driers, :type => :float
  col :annual_energy_from_electricity_for_clothes_driers_units
  col :annual_energy_from_electricity_for_dishwashers, :type => :float
  col :annual_energy_from_electricity_for_dishwashers_units
  col :annual_energy_from_electricity_for_freezers, :type => :float
  col :annual_energy_from_electricity_for_freezers_units
  col :annual_energy_from_electricity_for_heating_space, :type => :float
  col :annual_energy_from_electricity_for_heating_space_units
  col :annual_energy_from_electricity_for_heating_water, :type => :float
  col :annual_energy_from_electricity_for_heating_water_units
  col :annual_energy_from_electricity_for_other_appliances, :type => :float
  col :annual_energy_from_electricity_for_other_appliances_units
  col :annual_energy_from_electricity_for_refrigerators, :type => :float
  col :annual_energy_from_electricity_for_refrigerators_units
  col :annual_energy_from_fuel_oil_for_appliances, :type => :float
  col :annual_energy_from_fuel_oil_for_appliances_units
  col :annual_energy_from_fuel_oil_for_heating_space, :type => :float
  col :annual_energy_from_fuel_oil_for_heating_space_units
  col :annual_energy_from_fuel_oil_for_heating_water, :type => :float
  col :annual_energy_from_fuel_oil_for_heating_water_units
  col :annual_energy_from_kerosene, :type => :float
  col :annual_energy_from_kerosene_units
  col :annual_energy_from_natural_gas_for_appliances, :type => :float
  col :annual_energy_from_natural_gas_for_appliances_units
  col :annual_energy_from_natural_gas_for_heating_space, :type => :float
  col :annual_energy_from_natural_gas_for_heating_space_units
  col :annual_energy_from_natural_gas_for_heating_water, :type => :float
  col :annual_energy_from_natural_gas_for_heating_water_units
  col :annual_energy_from_propane_for_appliances, :type => :float
  col :annual_energy_from_propane_for_appliances_units
  col :annual_energy_from_propane_for_heating_space, :type => :float
  col :annual_energy_from_propane_for_heating_space_units
  col :annual_energy_from_propane_for_heating_water, :type => :float
  col :annual_energy_from_propane_for_heating_water_units
  col :annual_energy_from_wood, :type => :float
  col :annual_energy_from_wood_units
  col :attached_1car_garage, :type => :integer
  col :attached_2car_garage, :type => :integer
  col :attached_3car_garage, :type => :integer
  col :bathrooms, :type => :float
  col :bedrooms, :type => :integer
  col :census_division_name
  col :census_division_number, :type => :integer
  col :census_region_name
  col :census_region_number, :type => :integer
  col :central_ac_use
  col :clothes_dryer_use
  col :clothes_machine_use_id
  col :clothes_washer_use
  col :construction_period
  col :construction_year, :type => :date
  col :cooling_degree_days, :type => :integer
  col :cooling_degree_days_units
  col :detached_1car_garage, :type => :integer
  col :detached_2car_garage, :type => :integer
  col :detached_3car_garage, :type => :integer
  col :dishwasher_use_id
  col :efficient_lights_on_1_to_4_hours, :type => :integer
  col :efficient_lights_on_4_to_12_hours, :type => :integer
  col :efficient_lights_on_over_12_hours, :type => :integer
  col :floorspace, :type => :float
  col :floorspace_units
  col :freezer_count, :type => :integer
  col :full_bathrooms, :type => :integer
  col :half_bathrooms, :type => :integer
  col :heated_garage, :type => :integer
  col :heating_degree_days, :type => :integer
  col :heating_degree_days_units
  col :lighting_efficiency, :type => :float
  col :lighting_use, :type => :float
  col :lighting_use_units
  col :lights_on_1_to_4_hours, :type => :integer
  col :lights_on_4_to_12_hours, :type => :integer
  col :lights_on_over_12_hours, :type => :integer
  col :outdoor_all_night_gas_lights, :type => :integer
  col :outdoor_all_night_lights, :type => :integer
  col :ownership, :type => :boolean
  col :refrigerator_count, :type => :integer
  col :residence_class_id
  col :residents, :type => :integer
  col :rooms, :type => :float
  col :thermostat_programmability, :type => :boolean
  col :total_rooms, :type => :integer
  col :urbanity_id
  col :weighting, :type => :float
  col :window_ac_use
end