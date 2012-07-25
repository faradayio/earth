State.class_eval do
  data_miner do
    process "Start from scratch" do
      delete_all
    end
    
    # state names, FIPS codes, and postal abbreviations
    import 'the U.S. Census State ANSI Code file',
           :url => 'http://www.census.gov/geo/www/ansi/state.txt',
           :delimiter => '|',
           :select => proc { |record| record['STATE'].to_i < 60 } do
      key   'postal_abbreviation', :field_name => 'STUSAB'
      store 'fips_code',           :field_name => 'STATE'
      store 'name',                :field_name => 'STATE_NAME'
    end
    
    # census divisions
    import 'state census divisions from the U.S. Census',
           :url => 'http://www.census.gov/popest/about/geo/state_geocodes_v2009.txt',
           :skip => 8,
           :headers => ['Region', 'Division', 'State FIPS', 'Name'],
           :select => proc { |row| row['State FIPS'].to_i > 0 } do
      key   'fips_code', :field_name => 'State FIPS'
      store 'census_division_number', :field_name => 'Division'
    end
    
    # PADD
    import 'a list of state Petroleum Administration for Defense Districts',
           :url => 'http://spreadsheets.google.com/pub?key=t5HM1KbaRngmTUbntg8JwPA&gid=0&output=csv' do
      key   'postal_abbreviation', :field_name => 'State'
      store 'petroleum_administration_for_defense_district_code', :field_name => 'Code'
    end
    
    process 'ensure ZipCode and EgridSubregion are populated' do
      ZipCode.run_data_miner!
      EgridSubregion.run_data_miner!
    end
    
    # DEPRECATED - when cut this can also cut electricity_emission_factor from EgridSubrgion
    process 'derive average electricity emission factor and loss factor from zip code and eGRID data' do
      safe_find_each do |state|
        sub_pops = state.zip_codes.known_subregion.sum(:population, :group => :egrid_subregion)
        
        ef = sub_pops.inject(0) do |memo, (subregion, population)|
          memo += subregion.electricity_emission_factor * population
          memo
        end / sub_pops.values.sum
        
        state.update_attributes!(
          :electricity_emission_factor => ef,
          :electricity_emission_factor_units => 'kilograms_co2e_per_kilowatt_hour'
        )
        
        loss_factor = sub_pops.inject(0) do |memo, (subregion, population)|
          memo += subregion.egrid_region.loss_factor * population
          memo
        end / sub_pops.values.sum
        
        state.update_attributes! :electricity_loss_factor => loss_factor
      end
    end
    
    # TODO import this from US census? would be slightly different: 0.7% for Alaska, 0.2% for New Mexico, etc.
    process 'derive population from zip code data' do
      safe_find_each do |state|
        state.update_attributes! :population => state.zip_codes.sum(:population)
      end
    end
  end
end
