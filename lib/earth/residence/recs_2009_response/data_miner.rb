require 'earth/residence/recs_2009_response/parser'

Recs2009Response.class_eval do
  data_miner do
    import 'the 2009 EIA Residential Energy Consumption Survey microdata',
           # :url => "file:///Users/ian/Downloads/recs2009_test.csv",
           :url => "file:///Users/ian/Downloads/recs2009_public_v2.csv",
           :transform => { :class => Recs2009Response::Parser } do
      key   'id'
      store 'weighting'
      
      # location
      store 'census_region_number'
      store 'census_division_number'
      store 'recs_grouping_id'
      store 'urban_rural'
      store 'metro_micro'
      store 'climate_region_id'
      store 'climate_zone_id'
      store 'hdd_2009',         :from_units => :degrees_fahrenheit, :to_units => :degrees_celsius
      store 'hdd_avg',          :from_units => :degrees_fahrenheit, :to_units => :degrees_celsius
      store 'cdd_2009',         :from_units => :degrees_fahrenheit, :to_units => :degrees_celsius
      store 'cdd_avg',          :from_units => :degrees_fahrenheit, :to_units => :degrees_celsius
      
      # building
      store 'building_type'
      store 'converted_house'
      store 'condo_coop'
      store 'apartments'
      store 'year_built'
      store 'year_occupied'
      store 'building_floors'
      store 'levels'
      store 'area',           :from_units => :square_feet, :to_units => :square_metres
      store 'rooms'
      store 'bedrooms'
      store 'bathrooms'
      store 'half_baths'
      store 'other_rooms'
      store 'attic_rooms'
      store 'basement_rooms'
      store 'shaded'
      
      # outbuildings
      store 'garage'
      store 'garage_size'
      store 'garage_heated'
      store 'garage_cooled'
      store 'pool_fuel'
      store 'hot_tub_fuel'
      
      # envelope
      store 'slab'
      store 'crawlspace'
      store 'basement'
      store 'wall_material'
      store 'roof_material'
      store 'attic'
      store 'windows'
      store 'window_panes'
      store 'sliding_doors'
      store 'insulation'
      store 'drafty'
      store 'high_ceiling'
      
      # HVAC
      store 'heater'
      store 'heater_age'
      store 'heater_fuel'
      store 'heater_shared'
      store 'heater_thermostats'
      store 'heater_portion'
      store 'heater_2'
      store 'heater_2_fuel'
      store 'heater_3'
      store 'heater_3_fuel'
      store 'heater_4'
      store 'heater_4_fuel'
      store 'heater_5'
      store 'heater_5_fuel'
      store 'heater_6'
      store 'heater_6_fuel'
      store 'heater_unused'
      store 'heater_unused_fuel'
      store 'cooler_central_age'
      store 'cooler_central_shared'
      store 'cooler_acs'
      store 'cooler_ac_age'
      store 'cooler_ac_energy_star'
      store 'cooler_unused'
      store 'fans'
      
      # water heating
      store 'water_heater'
      store 'water_heater_fuel'
      store 'water_heater_size'
      store 'water_heater_age'
      store 'water_heater_shared'
      store 'water_heater_2'
      store 'water_heater_2_fuel'
      store 'water_heater_2_size'
      store 'water_heater_2_age'
      store 'storage_water_heaters'
      store 'tankless_water_heaters'
      
      # lighting
      store 'lights_high_use'
      store 'lights_high_use_efficient'
      store 'lights_med_use'
      store 'lights_med_use_efficient'
      store 'lights_low_use'
      store 'lights_low_use_efficient'
      store 'lights_outdoor'
      store 'lights_outdoor_efficient'
      
      # appliances
      store 'cooking_fuel'
      store 'stoves'
      store 'stove_fuel'
      store 'cooktops'
      store 'cooktop_fuel'
      store 'ovens'
      store 'oven_type'
      store 'oven_fuel'
      store 'outdoor_grill_fuel'
      store 'indoor_grill_fuel'
      store 'toaster'
      store 'coffee'
      
      store 'fridges'
      store 'fridge_type'
      store 'fridge_size'
      store 'fridge_defrost'
      store 'fridge_door_ice'
      store 'fridge_age'
      store 'fridge_energy_star'
      store 'fridge_2_type'
      store 'fridge_2_size'
      store 'fridge_2_defrost'
      store 'fridge_2_age'
      store 'fridge_2_energy_star'
      store 'fridge_3_type'
      store 'fridge_3_size'
      store 'fridge_3_defrost'
      store 'fridge_3_age'
      store 'fridge_3_energy_star'
      store 'freezers'
      store 'freezer_type'
      store 'freezer_size'
      store 'freezer_defrost'
      store 'freezer_age'
      store 'freezer_2_type'
      store 'freezer_2_size'
      store 'freezer_2_defrost'
      store 'freezer_2_age'
      store 'dishwasher_age'
      store 'dishwasher_energy_star'
      store 'washer'
      store 'washer_age'
      store 'washer_energy_star'
      store 'dryer_fuel'
      store 'dryer_age'
      
      # electronics
      store 'tvs'
      store 'tv_size'
      store 'tv_type'
      store 'tv_theater'
      store 'tv_2_size'
      store 'tv_2_type'
      store 'tv_2_theater'
      store 'tv_3_size'
      store 'tv_3_type'
      store 'tv_3_theater'
      store 'computers'
      store 'computer_type'
      store 'computer_monitor'
      store 'computer_2_type'
      store 'computer_2_monitor'
      store 'computer_3_type'
      store 'computer_3_monitor'
      store 'internet'
      store 'printers'
      store 'fax'
      store 'copier'
      store 'well_pump'
      store 'engine_block_heater'
      store 'aquarium'
      store 'stereo'
      store 'cordless_phone'
      store 'answering_machine'
      store 'tools'
      store 'electronics'
      
      # behaviour
      store 'home_business'
      store 'home_during_week'
      store 'telecommuting',         :units => :days_per_month
      store 'unusual_activities'
      store 'heat_area',             :from_units => :square_feet, :to_units => :square_metres
      store 'heat_rooms'
      store 'heat_attic_portion'
      store 'heat_basement_portion'
      store 'heat_temp_day',         :units => :degrees_fahrenheit
      store 'heat_temp_night',       :units => :degrees_fahrenheit
      store 'heat_temp_away',        :units => :degrees_fahrenheit
      store 'heat_auto_adjust_day'
      store 'heat_auto_adjust_night'
      store 'cool_area',             :from_units => :square_feet, :to_units => :square_metres
      store 'cool_rooms'
      store 'cool_attic_portion'
      store 'cool_basement_portion'
      store 'cool_temp_day',         :units => :degrees_fahrenheit
      store 'cool_temp_night',       :units => :degrees_fahrenheit
      store 'cool_temp_away',        :units => :degrees_fahrenheit
      store 'cool_auto_adjust_day'
      store 'cool_auto_adjust_night'
      store 'cooler_central_use'
      store 'cooler_ac_use'
      store 'fan_use'
      store 'humidifier_use',        :units => :months_per_year
      store 'dehumidifier_use',      :units => :months_per_year
      store 'oven_use',              :units => :times_per_month
      store 'microwave_use'
      store 'microwave_defrost'
      store 'cooking_frequency',     :units => :times_per_month
      store 'fridge_2_use',          :units => :months_per_year
      store 'fridge_3_use',          :units => :months_per_year
      store 'dishwasher_use',        :units => :times_per_month
      store 'washer_use',            :units => :times_per_month
      store 'washer_temp_wash'
      store 'washer_temp_rinse'
      store 'dryer_use'
      store 'tv_weekday_use',        :units => :hours_per_day
      store 'tv_weekend_use',        :units => :hours_per_day
      store 'tv_2_weekday_use',      :units => :hours_per_day
      store 'tv_2_weekend_use',      :units => :hours_per_day
      store 'tv_3_weekday_use',      :units => :hours_per_day
      store 'tv_3_weekend_use',      :units => :hours_per_day
      store 'computer_use',          :units => :hours_per_day
      store 'computer_idle'
      store 'computer_2_use',        :units => :hours_per_day
      store 'computer_2_idle'
      store 'computer_3_use',        :units => :hours_per_day
      store 'computer_3_idle'
      store 'tool_charging'
      store 'tool_vampires'
      store 'electronic_charging'
      store 'electronic_vampires'
      
      # improvements and incentives
      store 'energy_audit'
      store 'energy_audit_year'
      store 'energy_audit_incent'
      store 'energy_audit_incent_year'
      store 'insulation_added'
      store 'insulation_added_year'
      store 'insulation_incent'
      store 'insulation_incent_year'
      store 'windows_replaced'
      store 'windows_incent'
      store 'windows_incent_year'
      store 'caulking_added'
      store 'caulking_added_year'
      store 'caulking_incent'
      store 'caulking_incent_year'
      store 'heater_maintained'
      store 'heater_replaced'
      store 'heater_incent'
      store 'heater_incent_year'
      store 'cooler_central_maintained'
      store 'cooler_central_replaced'
      store 'cooler_central_incent'
      store 'cooler_central_incent_year'
      store 'cooler_ac_replaced'
      store 'cooler_ac_incent'
      store 'cooler_ac_incent_year'
      store 'water_heater_blanket'
      store 'water_heater_incent'
      store 'water_heater_incent_year'
      store 'lights_replaced'
      store 'lights_incent'
      store 'lights_incent_year'
      store 'dishwasher_replaced'
      store 'dishwasher_incent'
      store 'dishwasher_incent_year'
      store 'fridge_replaced'
      store 'fridge_incent'
      store 'fridge_incent_year'
      store 'freezer_replaced'
      store 'freezer_incent'
      store 'freezer_incent_year'
      store 'washer_replaced'
      store 'washer_incent'
      store 'washer_incent_year'
      store 'renewable_energy'
      
      # demographics
      store 'own_rent'
      store 'sex'
      store 'employment'
      store 'live_with_spouse'
      store 'race'
      store 'latino'
      store 'education'
      store 'household_size'
      store 'member_1_age'
      store 'member_2_age'
      store 'member_3_age'
      store 'member_4_age'
      store 'member_5_age'
      store 'member_6_age'
      store 'member_7_age'
      store 'member_8_age'
      store 'member_9_age'
      store 'member_10_age'
      store 'member_11_age'
      store 'member_12_age'
      store 'member_13_age'
      store 'member_14_age'
      store 'income'
      store 'income_employment'
      store 'income_retirement'
      store 'income_ssi'
      store 'income_welfare'
      store 'income_investment'
      store 'income_other'
      store 'poverty_100'
      store 'poverty_150'
      store 'public_housing_authority'
      store 'low_rent'
      store 'food_stamps'
      
      # who pays bills
      store 'pays_electricity_heat'
      store 'pays_electricity_water'
      store 'pays_electricity_cooking'
      store 'pays_electricity_cool'
      store 'pays_electricity_lighting'
      store 'pays_natural_gas_heat'
      store 'pays_natural_gas_water'
      store 'pays_natural_gas_cooking'
      store 'pays_natural_gas_other'
      store 'pays_fuel_oil'
      store 'pays_propane'
      
      # end uses
      store 'electricity_heat'
      store 'electricity_heat_2'
      store 'electricity_cool'
      store 'electricity_water'
      store 'electricity_cooking'
      store 'electricity_other'
      store 'natural_gas_heat'
      store 'natural_gas_heat_2'
      store 'natural_gas_water'
      store 'natural_gas_cooking'
      store 'natural_gas_other'
      store 'propane_heat'
      store 'propane_heat_2'
      store 'propane_water'
      store 'propane_cooking'
      store 'propane_other'
      store 'fuel_oil_heat'
      store 'fuel_oil_heat_2'
      store 'fuel_oil_water'
      store 'fuel_oil_other'
      store 'kerosene_heat'
      store 'kerosene_heat_2'
      store 'kerosene_water'
      store 'kerosene_other'
      store 'wood_heat'
      store 'wood_heat_2'
      store 'wood_water'
      store 'wood_other'
      store 'solar_heat'
      store 'solar_heat_2'
      store 'solar_water'
      store 'solar_other'
      store 'other_heat'
      store 'other_heat_2'
      store 'other_water'
      store 'other_cooking'
      
      # consumption
      store 'energy',           :from_units => :kbtus, :to_units => :megajoules
      store 'energy_cost',      :units => :dollars
      store 'electricity',      :units => :kilowatt_hours
      store 'electricity_cost', :units => :dollars
      store 'natural_gas',      :from_units => :kbtus, :to_units => :megajoules
      store 'natural_gas_cost', :units => :dollars
      store 'propane',          :from_units => :kbtus, :to_units => :megajoules
      store 'propane_cost',     :units => :dollars
      store 'fuel_oil',         :from_units => :kbtus, :to_units => :megajoules
      store 'fuel_oil_cost',    :units => :dollars
      store 'kerosene',         :from_units => :kbtus, :to_units => :megajoules
      store 'kerosene_cost',    :units => :dollars
      store 'wood',             :from_units => :kbtus, :to_units => :megajoules
    end
    
    process 'Correct any obvious problems with estimated move-in date' do
      where('year_occupied < year_built').update_all 'year_occupied = year_built'
    end
  end
end
