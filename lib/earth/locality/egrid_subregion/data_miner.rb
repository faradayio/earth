require 'earth/fuel/data_miner'

EgridSubregion.class_eval do
  data_miner do
    process "Start from scratch" do
      delete_all
    end
    
    import "eGRID 2012 subregion data",
           :url => 'http://www.epa.gov/cleanenergy/documents/egridzips/eGRID2012V1_0_year09_DATA.xls',
           :sheet => 'SRL09',
           :skip => 4 do
      key   'abbreviation',                    :field_name => 'SUBRGN'
      store 'name',                            :field_name => 'SRNAME'
      store 'nerc_abbreviation',               :field_name => 'NERC'
      store 'net_generation',                  :field_name => 'SRNGENAN', :units => :megawatt_hours
      store 'co2_emission_factor', :field_name => 'SRCO2RTA', :units => :pounds_per_megawatt_hour
      store 'co2_biogenic_emission_factor', :static => '0.0', :units => :kilograms_per_kilowatt_hour
      store 'ch4_emission_factor', :field_name => 'SRCH4RTA', :units => :pounds_per_gigawatt_hour
      store 'n2o_emission_factor', :field_name => 'SRN2ORTA', :units => :pounds_per_gigawatt_hour
    end
    
    import "eGRID subregion to region associations",
           :url => "file://#{Earth::DATA_DIR}/locality/egrid_relationships.csv" do
      key 'abbreviation'
      store 'egrid_region_name'
    end
    
    process "Convert co2 emission factors to metric units" do
      conversion_factor = 1.pounds.to(:kilograms) / 1_000.0 # kg / lbs * MWh / kWh
      where(:co2_emission_factor_units => 'pounds_per_megawatt_hour').update_all(%{
        co2_emission_factor = co2_emission_factor * #{conversion_factor},
        co2_emission_factor_units = 'kilograms_per_kilowatt_hour'
      })
    end
    
    process "Insure GreenhouseGas is populated" do
      GreenhouseGas.run_data_miner!
    end
    
    process "Convert ch4 emission factor to metric units and co2e" do
      conversion_factor = 1.pounds.to(:kilograms) / 1_000_000.0 # kg / lbs * GWh / kWh
      gwp = GreenhouseGas[:ch4].global_warming_potential
      where(:ch4_emission_factor_units => 'pounds_per_gigawatt_hour').update_all(%{
        ch4_emission_factor = ch4_emission_factor * #{conversion_factor} * #{gwp},
        ch4_emission_factor_units = 'kilograms_co2e_per_kilowatt_hour'
      })
    end
    
    process "Convert n2o emission factor to metric units and co2e" do
      conversion_factor = 1.pounds.to(:kilograms) / 1_000_000.0 # kg / lbs * GWh / kWh
      gwp = GreenhouseGas[:n2o].global_warming_potential
      where(:n2o_emission_factor_units => 'pounds_per_gigawatt_hour').update_all(%{
        n2o_emission_factor = n2o_emission_factor * #{conversion_factor} * #{gwp},
        n2o_emission_factor_units = 'kilograms_co2e_per_kilowatt_hour'
      })
    end
    
    process "Calculate combined emission factor" do
      update_all(%{
        electricity_emission_factor = co2_emission_factor + ch4_emission_factor + n2o_emission_factor,
        electricity_emission_factor_units = 'kilograms_co2e_per_kilowatt_hour'
      })
    end
  end
end
