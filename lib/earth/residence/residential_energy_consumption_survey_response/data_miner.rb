require 'earth/locality/data_miner'
ResidentialEnergyConsumptionSurveyResponse.class_eval do
  data_miner do
    process "Define some unit conversions" do
      Conversions.register :kbtus, :joules, 1_000.0 * 1_055.05585
      Conversions.register :square_feet, :square_metres, 0.09290304
    end
    
    # conversions are NOT performed here, since we first have to zero out legitimate skips
    # otherwise you will get values like "999 pounds = 453.138778 kilograms" (where 999 is really a legit skip)
    import 'the 2005 EIA Residential Energy Consumption Survey microdata',
           :url => 'http://www.eia.doe.gov/emeu/recs/recspubuse05/datafiles/RECS05alldata.csv',
           :headers => :upcase do
      key   'id', :field_name => 'DOEID'
      
      store 'residence_class_id', :field_name => 'TYPEHUQ', :dictionary => { :input => 'Code', :output => 'Description', :url => 'https://raw.github.com/brighterplanet/manually_curated_data/master/typehuq/typehuq.csv' }
      store 'construction_year', :field_name => 'YEARMADE', :dictionary => { :input => 'Code', :sprintf => '%02d', :output => 'Date in the middle (synthetic)', :url => 'https://raw.github.com/brighterplanet/manually_curated_data/master/yearmade/yearmade.csv' }
      store 'construction_period', :field_name => 'YEARMADE', :dictionary => { :input => 'Code', :sprintf => '%02d', :output => 'Description', :url => 'https://raw.github.com/brighterplanet/manually_curated_data/master/yearmade/yearmade.csv' }
      store 'urbanity_id', :field_name => 'URBRUR', :dictionary => { :input => 'Code', :output => 'Description', :url => 'https://raw.github.com/brighterplanet/manually_curated_data/master/urbrur/urbrur.csv' }
      store 'dishwasher_use_id', :field_name => 'DWASHUSE', :dictionary => { :input => 'Code', :output => 'Description', :url => 'https://raw.github.com/brighterplanet/manually_curated_data/master/dwashuse/dwashuse.csv' }
      store 'central_ac_use', :field_name => 'USECENAC', :dictionary => { :input => 'Code', :output => 'Description', :url => 'https://raw.github.com/brighterplanet/manually_curated_data/master/usecenac/usecenac.csv' }
      store 'window_ac_use', :field_name => 'USEWWAC', :dictionary => { :input => 'Code', :output => 'Description', :url => 'https://raw.github.com/brighterplanet/manually_curated_data/master/usewwac/usewwac.csv' }
      store 'clothes_washer_use', :field_name => 'WASHLOAD', :dictionary => { :input => 'Code', :output => 'Description', :url => 'https://raw.github.com/brighterplanet/manually_curated_data/master/washload/washload.csv' }
      store 'clothes_dryer_use', :field_name => 'DRYRUSE', :dictionary => { :input => 'Code', :output => 'Description', :url => 'https://raw.github.com/brighterplanet/manually_curated_data/master/dryruse/dryruse.csv' }
      
      store 'census_division_number', :field_name => 'DIVISION'
      store 'census_division_name', :field_name => 'DIVISION', :dictionary => { :input => 'number', :output => 'name', :url => 'http://data.brighterplanet.com/census_divisions.csv' }
      store 'census_region_number', :field_name => 'DIVISION', :dictionary => { :input => 'number', :output => 'census_region_number', :url => 'http://data.brighterplanet.com/census_divisions.csv' }
      store 'census_region_name', :field_name => 'DIVISION', :dictionary => { :input => 'number', :output => 'census_region_name', :url => 'http://data.brighterplanet.com/census_divisions.csv' }
      
      store 'floorspace', :field_name => 'TOTSQFT', :units => :square_metres
      store 'residents', :field_name => 'NHSLDMEM'
      store 'refrigerator_count', :field_name => 'NUMFRIG'
      store 'freezer_count', :field_name => 'NUMFREEZ'
      store 'heating_degree_days', :field_name => 'HD65', :units => :degrees_fahrenheit_days # FIXME imperial
      store 'cooling_degree_days', :field_name => 'CD65', :units => :degrees_fahrenheit_days # FIXME imperial
      store 'annual_energy_from_fuel_oil_for_heating_space', :field_name => 'BTUFOSPH', :units => :joules
      store 'annual_energy_from_fuel_oil_for_heating_water', :field_name => 'BTUFOWTH', :units => :joules
      store 'annual_energy_from_fuel_oil_for_appliances', :field_name => 'BTUFOAPL', :units => :joules
      store 'annual_energy_from_natural_gas_for_heating_space', :field_name => 'BTUNGSPH', :units => :joules
      store 'annual_energy_from_natural_gas_for_heating_water', :field_name => 'BTUNGWTH', :units => :joules
      store 'annual_energy_from_natural_gas_for_appliances', :field_name => 'BTUNGAPL', :units => :joules
      store 'annual_energy_from_propane_for_heating_space', :field_name => 'BTULPSPH', :units => :joules
      store 'annual_energy_from_propane_for_heating_water', :field_name => 'BTULPWTH', :units => :joules
      store 'annual_energy_from_propane_for_appliances', :field_name => 'BTULPAPL', :units => :joules
      store 'annual_energy_from_wood', :field_name => 'BTUWOOD', :units => :joules
      store 'annual_energy_from_kerosene', :field_name => 'BTUKER', :units => :joules
      store 'annual_energy_from_electricity_for_clothes_driers', :field_name => 'BTUELCDR', :units => :joules
      store 'annual_energy_from_electricity_for_dishwashers', :field_name => 'BTUELDWH', :units => :joules
      store 'annual_energy_from_electricity_for_freezers', :field_name => 'BTUELFZZ', :units => :joules
      store 'annual_energy_from_electricity_for_refrigerators', :field_name => 'BTUELRFG', :units => :joules
      store 'annual_energy_from_electricity_for_air_conditioners', :field_name => 'BTUELCOL', :units => :joules
      store 'annual_energy_from_electricity_for_heating_space', :field_name => 'BTUELSPH', :units => :joules
      store 'annual_energy_from_electricity_for_heating_water', :field_name => 'BTUELWTH', :units => :joules
      store 'annual_energy_from_electricity_for_other_appliances', :field_name => 'BTUELAPL', :units => :joules
      store 'weighting', :field_name => 'NWEIGHT'
      store 'lighting_use', :static => nil, :units => :hours
      store 'total_rooms', :field_name => 'TOTROOMS'
      store 'full_bathrooms', :field_name => 'NCOMBATH'
      store 'half_bathrooms', :field_name => 'NHAFBATH'
      store 'bedrooms', :field_name => 'BEDROOMS'
      store 'lights_on_1_to_4_hours', :field_name => 'LGT1'
      store 'efficient_lights_on_1_to_4_hours', :field_name => 'LGT1EE'
      store 'lights_on_4_to_12_hours', :field_name => 'LGT4'
      store 'efficient_lights_on_4_to_12_hours', :field_name => 'LGT4EE'
      store 'lights_on_over_12_hours', :field_name => 'LGT12'
      store 'efficient_lights_on_over_12_hours', :field_name => 'LGT12EE'
      store 'outdoor_all_night_lights', :field_name => 'NOUTLGTNT'
      store 'outdoor_all_night_gas_lights', :field_name => 'NGASLIGHT'
      # integers where we treat anything other than true (for example legitimate skip or "occupied without paying rent") as 0
      store 'heated_garage', :synthesize => lambda { |row| row['GARGHEAT'] == '1' ? 1 : 0 }
      store 'attached_1car_garage', :synthesize => lambda { |row| row['GARAGE1C'] == '1' ? 1 : 0 }
      store 'detached_1car_garage', :synthesize => lambda { |row| row['DGARG1C'] == '1' ? 1 : 0 }
      store 'attached_2car_garage', :synthesize => lambda { |row| row['GARAGE2C'] == '1' ? 1 : 0 }
      store 'detached_2car_garage', :synthesize => lambda { |row| row['DGARG2C'] == '1' ? 1 : 0 }
      store 'attached_3car_garage', :synthesize => lambda { |row| row['GARAGE3C'] == '1' ? 1 : 0 }
      store 'detached_3car_garage', :synthesize => lambda { |row| row['DGARG3C'] == '1' ? 1 : 0 }
      # booleans where we treat anything other than true (for example legitimate skip or "occupied without paying rent") as false
      store 'ownership', :synthesize => lambda { |row| row['KOWNRENT'] == '1' }
      store 'thermostat_programmability', :synthesize => lambda { |row| row['PROTHERM'] == '1' }
    end

    # Rather than nullify the continuous variables that EIA identifies as LEGITIMATE SKIPS, we convert them to zero
    # This makes it easier to derive useful information like "how many rooms does the house have?"
    process "Zero out what the EIA calls LEGITIMATE SKIPS" do
      %w{
        annual_energy_from_electricity_for_air_conditioners
        annual_energy_from_electricity_for_clothes_driers
        annual_energy_from_electricity_for_dishwashers
        annual_energy_from_electricity_for_freezers
        annual_energy_from_electricity_for_heating_space
        annual_energy_from_electricity_for_heating_water
        annual_energy_from_electricity_for_other_appliances
        annual_energy_from_electricity_for_refrigerators
        annual_energy_from_fuel_oil_for_appliances
        annual_energy_from_fuel_oil_for_heating_space
        annual_energy_from_fuel_oil_for_heating_water
        annual_energy_from_kerosene
        annual_energy_from_propane_for_appliances
        annual_energy_from_propane_for_heating_space
        annual_energy_from_propane_for_heating_water
        annual_energy_from_natural_gas_for_appliances
        annual_energy_from_natural_gas_for_heating_space
        annual_energy_from_natural_gas_for_heating_water
        annual_energy_from_wood
        lights_on_1_to_4_hours
        lights_on_over_12_hours
        efficient_lights_on_over_12_hours
        efficient_lights_on_1_to_4_hours
        lights_on_4_to_12_hours
        efficient_lights_on_4_to_12_hours
        outdoor_all_night_gas_lights
        outdoor_all_night_lights
      }.each do |attr_name|
        max = maximum attr_name, :select => "CONVERT(#{attr_name}, UNSIGNED INTEGER)"
        # if the maximum value of a row is all 999's, then it's a LEGITIMATE SKIP and we should set it to zero
        if /^9+$/.match(max.to_i.to_s)
          where(attr_name => max).update_all attr_name => 0
        end
      end
    end

    process "Convert units to metric" do
      [
        [ 'floorspace', :square_feet, :square_metres ],
        [ 'annual_energy_from_fuel_oil_for_heating_space', :kbtus, :joules ],
        [ 'annual_energy_from_fuel_oil_for_heating_water', :kbtus, :joules ],
        [ 'annual_energy_from_fuel_oil_for_appliances', :kbtus, :joules ],
        [ 'annual_energy_from_natural_gas_for_heating_space', :kbtus, :joules ],
        [ 'annual_energy_from_natural_gas_for_heating_water', :kbtus, :joules ],
        [ 'annual_energy_from_natural_gas_for_appliances', :kbtus, :joules ],
        [ 'annual_energy_from_propane_for_heating_space', :kbtus, :joules ],
        [ 'annual_energy_from_propane_for_heating_water', :kbtus, :joules ],
        [ 'annual_energy_from_propane_for_appliances', :kbtus, :joules ],
        [ 'annual_energy_from_wood', :kbtus, :joules ],
        [ 'annual_energy_from_kerosene', :kbtus, :joules ],
        [ 'annual_energy_from_electricity_for_clothes_driers', :kbtus, :joules ],
        [ 'annual_energy_from_electricity_for_dishwashers', :kbtus, :joules ],
        [ 'annual_energy_from_electricity_for_freezers', :kbtus, :joules ],
        [ 'annual_energy_from_electricity_for_refrigerators', :kbtus, :joules ],
        [ 'annual_energy_from_electricity_for_air_conditioners', :kbtus, :joules ],
        [ 'annual_energy_from_electricity_for_heating_space', :kbtus, :joules ],
        [ 'annual_energy_from_electricity_for_heating_water', :kbtus, :joules ],
        [ 'annual_energy_from_electricity_for_other_appliances', :kbtus, :joules ],
      ].each do |attr_name, from_units, to_units|
        update_all "#{attr_name} = 1.0 * #{attr_name} * #{Conversions::Unit.exchange_rate from_units, to_units}"
      end
    end
      
    process 'Add a new field "rooms" that estimates how many rooms are in the house' do
      update_all 'rooms = total_rooms + full_bathrooms/2.0 + half_bathrooms/4.0 + 1.0*heated_garage*(attached_1car_garage + detached_1car_garage + 2.0*(attached_2car_garage + detached_2car_garage) + 3.0*(attached_3car_garage + detached_3car_garage))'
    end
    
    process 'Add a new field "bathrooms" that synthesizes half and full bathrooms into one number' do
      update_all 'bathrooms = full_bathrooms + 0.5*half_bathrooms'
    end
    
    process 'Add a new field "lighting_use" that estimates how many hours light bulbs are turned on in the house' do
      update_all 'lighting_use = 2.0*(lights_on_1_to_4_hours + efficient_lights_on_1_to_4_hours) + 8.0*(lights_on_4_to_12_hours + efficient_lights_on_4_to_12_hours) + 16.0*(lights_on_over_12_hours + efficient_lights_on_over_12_hours) + 12.0*(outdoor_all_night_lights + outdoor_all_night_gas_lights)'
    end
    
    process 'Add a new field "lighting_efficiency" that estimates what percentage of light bulbs in a house are energy-efficient' do
      update_all 'lighting_efficiency = (2.0*efficient_lights_on_1_to_4_hours + 8.0*efficient_lights_on_4_to_12_hours + 16.0*efficient_lights_on_over_12_hours) / lighting_use', 'lighting_use > 0'
    end
    
    process "synthesize air conditioner use from central AC and window AC use" do
      #          SET                                                                                  WHERE
      update_all "air_conditioner_use_id = 'Turned on just about all summer'",                        " central_ac_use = 'Turned on just about all summer'                        OR window_ac_use = 'Turned on just about all summer'"
      update_all "air_conditioner_use_id = 'Turned on quite a bit'",                                  "(central_ac_use = 'Turned on quite a bit'                                  OR window_ac_use = 'Turned on quite a bit')                                  AND air_conditioner_use_id IS NULL"
      update_all "air_conditioner_use_id = 'Turned on only a few days or nights when really needed'", "(central_ac_use = 'Turned on only a few days or nights when really needed' OR window_ac_use = 'Turned on only a few days or nights when really needed') AND air_conditioner_use_id IS NULL"
      update_all "air_conditioner_use_id = 'Not used at all'",                                        "(central_ac_use = 'Not used at all'                                        OR window_ac_use = 'Not used at all')                                        AND air_conditioner_use_id IS NULL"
    end
    
    process "synthesize clothes machine use from washer and dryer use" do
      #          SET                                                    WHERE
      update_all "clothes_machine_use_id = clothes_washer_use",         "                                                    clothes_dryer_use = 'Use it every time you wash clothes'"
      update_all "clothes_machine_use_id = NULL",                       "clothes_washer_use IS NULL                      AND clothes_dryer_use = 'Use it for some, but not all, loads of wash'"
      update_all "clothes_machine_use_id = '1 load or less each week'", "clothes_washer_use = '1 load or less each week' AND clothes_dryer_use = 'Use it for some, but not all, loads of wash'"
      update_all "clothes_machine_use_id = '1 load or less each week'", "clothes_washer_use = '2 to 4 loads'             AND clothes_dryer_use = 'Use it for some, but not all, loads of wash'"
      update_all "clothes_machine_use_id = '2 to 4 loads'",             "clothes_washer_use = '5 to 9 loads'             AND clothes_dryer_use = 'Use it for some, but not all, loads of wash'"
      update_all "clothes_machine_use_id = '5 to 9 loads'",             "clothes_washer_use = '10 to 15 loads'           AND clothes_dryer_use = 'Use it for some, but not all, loads of wash'"
      update_all "clothes_machine_use_id = '10 to 15 loads'",           "clothes_washer_use = 'More than 15 loads'       AND clothes_dryer_use = 'Use it for some, but not all, loads of wash'"
      update_all "clothes_machine_use_id = NULL",                       "clothes_washer_use IS NULL                      AND clothes_dryer_use = 'Use it infrequently'"
      update_all "clothes_machine_use_id = '1 load or less each week'", "clothes_washer_use = '1 load or less each week' AND clothes_dryer_use = 'Use it infrequently'"
      update_all "clothes_machine_use_id = '1 load or less each week'", "clothes_washer_use = '5 to 9 loads'             AND clothes_dryer_use = 'Use it infrequently'"
      update_all "clothes_machine_use_id = '2 to 4 loads'",             "clothes_washer_use = '10 to 15 loads'           AND clothes_dryer_use = 'Use it infrequently'"
      update_all "clothes_machine_use_id = '5 to 9 loads'",             "clothes_washer_use = 'More than 15 loads'       AND clothes_dryer_use = 'Use it infrequently'"
    end
    
    # FIXME add precalc bathrooms per https://github.com/brighterplanet/cm1/commit/77df97c50311f3c59aad891f018bf3d487afeb98
  end
end
