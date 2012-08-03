require 'earth/fuel/greenhouse_gas'
require 'earth/locality/egrid_subregion'
require 'earth/locality/state'

ElectricityMix.class_eval do
  data_miner do
    process "Ensure GreenhouseGas is populated" do
      GreenhouseGas.run_data_miner!
    end
    
    process "Ensure EgridSubregion is populated" do
      EgridSubregion.run_data_miner!
    end
    
    import "national electricity mixes from Brander et al. (2011)",
           :url => "file://#{Earth::DATA_DIR}/locality/national_electricity_efs.csv" do
      key :name, :synthesize => lambda { |row| [row['country_iso_3166_code'], 'national electricity'].join(' ') }
      store :country_iso_3166_code
      store :co2_emission_factor, :units_field_name => 'co2_emission_factor_units'
      store :ch4_emission_factor, :synthesize => proc { |row| row['ch4_emission_factor'].to_f * GreenhouseGas[:ch4].global_warming_potential }, :units => 'kilograms_co2e_per_kilowatt_hour'
      store :n2o_emission_factor, :synthesize => proc { |row| row['n2o_emission_factor'].to_f * GreenhouseGas[:n2o].global_warming_potential }, :units => 'kilograms_co2e_per_kilowatt_hour'
      store :loss_factor
    end
    
    process "Derive eGRID subregion electricity mixes" do
      EgridSubregion.safe_find_each do |subregion|
        mix = find_or_create_by_name [subregion.abbreviation, 'egrid subregion electricity'].join(' ')
        mix.update_attributes!(
          :egrid_subregion_abbreviation => subregion.abbreviation,
          :co2_emission_factor =>          subregion.co2_emission_factor,
          :co2_emission_factor_units =>    subregion.co2_emission_factor_units,
          :ch4_emission_factor =>          subregion.ch4_emission_factor,
          :ch4_emission_factor_units =>    subregion.ch4_emission_factor_units,
          :n2o_emission_factor =>          subregion.n2o_emission_factor,
          :n2o_emission_factor_units =>    subregion.n2o_emission_factor_units,
          :loss_factor =>                  subregion.egrid_region.loss_factor
        )
      end
    end
    
    process "Derive US electricity mix from EgridSubregion" do
      us = find_by_country_iso_3166_code 'US'
      us.update_attributes!(
        :co2_emission_factor =>       EgridSubregion.fallback.co2_emission_factor,
        :co2_emission_factor_units => EgridSubregion.fallback.co2_emission_factor_units,
        :ch4_emission_factor =>       EgridSubregion.fallback.ch4_emission_factor,
        :ch4_emission_factor_units => EgridSubregion.fallback.ch4_emission_factor_units,
        :n2o_emission_factor =>       EgridSubregion.fallback.n2o_emission_factor,
        :n2o_emission_factor_units => EgridSubregion.fallback.n2o_emission_factor_units,
        :loss_factor =>               EgridSubregion.fallback.egrid_region.loss_factor
      )
    end
    
    process "Ensure State is populated" do
      State.run_data_miner!
    end
    
    process "Derive state electricity mixes" do
      State.safe_find_each do |state|
        mix = find_or_create_by_name_and_state_postal_abbreviation(
          [state.postal_abbreviation, 'state electricity'].join(' '), state.postal_abbreviation
        )
        
        sub_pops = state.zip_codes.known_subregion.sum(:population, :group => :egrid_subregion)
        
        %w{ co2 ch4 n2o }.each do |gas|
          ef = sub_pops.inject(0) do |memo, (subregion, population)|
            memo += subregion.send("#{gas}_emission_factor") * population
            memo
          end / sub_pops.values.sum
          
          mix.update_attributes!(
            "#{gas}_emission_factor" => ef,
            "#{gas}_emission_factor_units" => sub_pops.keys.first.send("#{gas}_emission_factor_units")
          )
        end
        
        lf = sub_pops.inject(0) do |memo, (subregion, population)|
          memo += subregion.egrid_region.loss_factor * population
          memo
        end / sub_pops.values.sum
        
        mix.update_attributes! :loss_factor => lf
      end
    end
  end
end
