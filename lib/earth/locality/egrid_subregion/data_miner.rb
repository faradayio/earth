require 'earth/fuel/greenhouse_gas'
require 'earth/locality/egrid_country'

EgridSubregion.class_eval do
  data_miner do
    import "eGRID 2012 subregion data",
           :url => 'http://www.epa.gov/cleanenergy/documents/egridzips/eGRID2012V1_0_year09_DATA.xls',
           :sheet => 'SRL09',
           :skip => 4 do
      key   'abbreviation',                    :field_name => 'SUBRGN'
      store 'name',                            :field_name => 'SRNAME'
      store 'nerc_abbreviation',               :field_name => 'NERC'
      store 'net_generation',                  :field_name => 'SRNGENAN', :units => :megawatt_hours
      store 'co2_emission_factor', :field_name => 'SRCO2RTA', :from_units => :pounds_per_megawatt_hour, :to_units => :kilograms_per_kilowatt_hour
      store 'ch4_emission_factor', :field_name => 'SRCH4RTA', :from_units => :pounds_per_gigawatt_hour, :to_units => :kilograms_per_kilowatt_hour
      store 'n2o_emission_factor', :field_name => 'SRN2ORTA', :from_units => :pounds_per_gigawatt_hour, :to_units => :kilograms_per_kilowatt_hour
    end
    
    import "eGRID subregion to region associations",
           :url => "file://#{Earth::DATA_DIR}/locality/egrid_relationships.csv" do
      key 'abbreviation'
      store 'egrid_region_name'
    end
    
    process "Ensure EgridCountry is populated" do
      EgridCountry.run_data_miner!
    end

    process "Ensure GreenhouseGas is populated" do
      GreenhouseGas.run_data_miner!
    end
    
    %w{ ch4 n2o }.each do |gas|
      process "Convert #{gas} emission factors to co2e" do
        gwp = GreenhouseGas[gas].global_warming_potential
        
        where("#{gas}_emission_factor_units = 'kilograms_per_kilowatt_hour'").update_all(%{
          #{gas}_emission_factor = #{gas}_emission_factor * #{gwp},
          #{gas}_emission_factor_units = 'kilograms_co2e_per_kilowatt_hour'
        })
      end
    end
    
    # DEPRECATED - but don't remove until cut State.electricity_emission_factor
    process "Calculate combined electricity emission factor" do
      update_all %{
        electricity_emission_factor = co2_emission_factor + ch4_emission_factor + n2o_emission_factor,
        electricity_emission_factor_units = 'kilograms_co2e_per_kilowatt_hour'
      }
    end
  end
end
