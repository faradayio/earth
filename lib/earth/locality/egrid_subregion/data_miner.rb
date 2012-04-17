require 'earth/fuel/data_miner'
EgridSubregion.class_eval do
  data_miner do
    import "eGRID 2010 subregions and electricity emission factors",
           :url => 'http://www.epa.gov/cleanenergy/documents/egridzips/eGRID2010_Version1-1_xls_only.zip',
           :filename => 'eGRID2010V1_1_year07_AGGREGATION.xls',
           :sheet => 'SRL07',
           :skip => 4,
           :select => proc { |row| row['SEQSRL07'].to_i.between?(1, 26) } do
      key   'abbreviation', :field_name => 'SUBRGN'
      store 'name', :field_name => 'SRNAME'
      store 'nerc_abbreviation',               :field_name => 'NERC'
      store 'net_generation',                  :field_name => 'SRNGENAN', :units => :megawatt_hours
      store 'electricity_co2_emission_factor', :field_name => 'SRCO2RTA', :units => :pounds_per_megawatt_hour
      store 'electricity_co2_biogenic_emission_factor', :static => '0.0', :units => :kilograms_per_kilowatt_hour
      store 'electricity_ch4_emission_factor', :field_name => 'SRCH4RTA', :units => :pounds_per_gigawatt_hour
      store 'electricity_n2o_emission_factor', :field_name => 'SRN2ORTA', :units => :pounds_per_gigawatt_hour
    end
    
    # FIXME TODO once 'US' subregion is no longer needed remove it from this source file
    import "eGRID subregion to region associations",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdGRORTJNSWRMQ1puRVprYlAtZHhDaFE&output=csv' do
      key 'abbreviation'
      store 'egrid_region_name'
    end
    
    # DEPRECATED but don't remove until confirmed that all emitters use EgridSubregion.fallback rather than EgridSubregion.find_by_abbreviation 'US'
    # (ElectricityUse and Meeting)
    process "Calculate national averages" do
      us_average = find_by_abbreviation 'US'
      subregions = where("abbreviation != 'US'")
      
      us_average.name = 'United States'
      us_average.nerc_abbreviation = 'US'
      us_average.egrid_region_name = 'US'
      us_average.net_generation                           = subregions.sum(:net_generation)
      us_average.electricity_co2_emission_factor          = subregions.weighted_average(:electricity_co2_emission_factor, :weighted_by => :net_generation)
      us_average.electricity_co2_biogenic_emission_factor = subregions.weighted_average(:electricity_co2_biogenic_emission_factor, :weighted_by => :net_generation)
      us_average.electricity_ch4_emission_factor          = subregions.weighted_average(:electricity_ch4_emission_factor, :weighted_by => :net_generation)
      us_average.electricity_n2o_emission_factor          = subregions.weighted_average(:electricity_n2o_emission_factor, :weighted_by => :net_generation)
      us_average.net_generation_units                           = 'megawatt_hours'
      us_average.electricity_co2_emission_factor_units          = 'pounds_per_megawatt_hour'
      us_average.electricity_co2_biogenic_emission_factor_units = 'kilograms_per_kilowatt_hour'
      us_average.electricity_ch4_emission_factor_units          = 'pounds_per_gigawatt_hour'
      us_average.electricity_n2o_emission_factor_units          = 'pounds_per_gigawatt_hour'
      us_average.save!
    end
    
    process "Convert co2 emission factor to metric units" do
      conversion_factor = 1.pounds.to(:kilograms) / 1_000.0 # kg / lbs * MWh / kWh
      where(:electricity_co2_emission_factor_units => 'pounds_per_megawatt_hour').update_all(%{
        electricity_co2_emission_factor = 1.0 * electricity_co2_emission_factor * #{conversion_factor},
        electricity_co2_emission_factor_units = 'kilograms_per_kilowatt_hour'
      })
    end
    
    process "Insure GreenhouseGas is populated" do
      GreenhouseGas.run_data_miner!
    end
    
    process "Convert ch4 emission factor to metric units and co2e" do
      conversion_factor = 1.pounds.to(:kilograms) / 1_000_000.0 # kg / lbs * GWh / kWh
      gwp = GreenhouseGas[:ch4].global_warming_potential
      where(:electricity_ch4_emission_factor_units => 'pounds_per_gigawatt_hour').update_all(%{
        electricity_ch4_emission_factor = 1.0 * electricity_ch4_emission_factor * #{conversion_factor} * #{gwp},
        electricity_ch4_emission_factor_units = 'kilograms_co2e_per_kilowatt_hour'
      })
    end
    
    process "Convert n2o emission factor to metric units and co2e" do
      conversion_factor = 1.pounds.to(:kilograms) / 1_000_000.0 # kg / lbs * GWh / kWh
      gwp = GreenhouseGas[:n2o].global_warming_potential
      where(:electricity_n2o_emission_factor_units => 'pounds_per_gigawatt_hour').update_all(%{
        electricity_n2o_emission_factor = 1.0 * electricity_n2o_emission_factor * #{conversion_factor} * #{gwp},
        electricity_n2o_emission_factor_units = 'kilograms_co2e_per_kilowatt_hour'
      })
    end
    
    process "Calculate combined emission factor" do
      update_all(%{
        electricity_emission_factor = 1.0 * electricity_co2_emission_factor + electricity_ch4_emission_factor + electricity_n2o_emission_factor,
        electricity_emission_factor_units = 'kilograms_co2e_per_kilowatt_hour'
      })
    end
  end
end
