EgridSubregion.class_eval do
  data_miner do
    # FIXME TODO for some reason this doesn't work...
    # import "eGRID regions and electricity emission factors derived from eGRID 2007 data",
    #        :url => 'http://www.epa.gov/cleanenergy/documents/egridzips/eGRID2007_Version1-1.zip',
    #        :filename => 'eGRID2007_Version1-1/eGRID2007V1_1_year05_aggregation.xls',
    #        :sheet => 'SRL05',
    #        :skip => 3,
    #        :select => lambda { |row| row['eGRID2007 2005 file eGRID subregion location (operator)-based sequence number'].to_i.between?(1, 26) } do
    #   key   'abbreviation', :field_name => 'eGRID subregion acronym'
    #   store 'name', :field_name => 'eGRID subregion name associated with eGRID subregion acronym'
    #   store 'nerc_abbreviation', :field_name => 'NERC region acronym associated with the eGRID subregion acronym'
    #   store 'net_generation', :field_name => 'eGRID subregion annual net generation (MWh)', :units => 'megawatt_hours'
    #   store 'electricity_co2_emission_factor', :field_name => 'eGRID subregion annual CO2 output emission rate (lb/MWh)', :units => 'pounds_per_megawatt_hour'
    #   store 'electricity_co2_biogenic_emission_factor', :static => '0.0', :units => 'kilograms_per_kilowatt_hour'
    #   store 'electricity_ch4_emission_factor', :field_name => 'eGRID subregion annual CH4 output emission rate (lb/GWh)', :units => 'pounds_per_gigawatt_hour'
    #   store 'electricity_n2o_emission_factor', :field_name => 'eGRID subregion annual N2O output emission rate (lb/GWh)', :units => 'pounds_per_gigawatt_hour'
    # end
    
    import "eGRID subregion data",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdGRORTJNSWRMQ1puRVprYlAtZHhDaFE&hl=en&gid=0&output=csv' do
      key 'abbreviation'
      store 'name'
      store 'nerc_abbreviation'
      store 'egrid_region_name'
      store 'net_generation', :units => 'megawatt_hours'
      store 'electricity_co2_emission_factor', :field_name => 'electricty_ef_co2', :units => 'pounds_per_megawatt_hour'
      store 'electricity_co2_biogenic_emission_factor', :static => '0.0', :units => 'kilograms_per_kilowatt_hour'
      store 'electricity_ch4_emission_factor', :field_name => 'electricity_ef_ch4',  :units => 'pounds_per_gigawatt_hour'
      store 'electricity_n2o_emission_factor', :field_name => 'electricity_ef_n2o',  :units => 'pounds_per_gigawatt_hour'
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
