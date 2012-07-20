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
    
    process 'ensure ZipCode, EgridSubregion, and EgridRegion are populated' do
      ZipCode.run_data_miner!
      EgridSubregion.run_data_miner!
      EgridRegion.run_data_miner!
    end
    
    process 'derive average electricity emission factor and loss factor from zip code and eGRID data' do
      safe_find_each do |state|
        subregion_populations = state.zip_codes.where("egrid_subregion_abbreviation IS NOT NULL").sum(:population, :group => :egrid_subregion)
        
        ef = subregion_populations.inject(0) do |memo, (subregion, population)|
          memo += subregion.electricity_emission_factor * population
          memo
        end / subregion_populations.values.sum
        
        state.update_attributes!(
          :electricity_emission_factor => ef,
          :electricity_emission_factor_units => 'kilograms_co2e_per_kilowatt_hour'
        )
        
        loss_factor = subregion_populations.inject(0) do |memo, (subregion, population)|
          memo += subregion.egrid_region.loss_factor * population
          memo
        end / subregion_populations.values.sum
        
        state.update_attributes! :electricity_loss_factor => loss_factor
      end
      
      # Same thing using SQL:
      # update_all %{
      #   electricity_emission_factor = (
      #     SELECT SUM(zip_codes.population * egrid_subregions.electricity_emission_factor) / SUM(zip_codes.population)
      #     FROM zip_codes
      #     INNER JOIN egrid_subregions ON egrid_subregions.abbreviation = zip_codes.egrid_subregion_abbreviation
      #     WHERE zip_codes.state_postal_abbreviation = states.postal_abbreviation
      #   ),
      #   electricity_emission_factor_units = 'kilograms_co2e_per_kilowatt_hour',
      #   electricity_loss_factor = (
      #     SELECT SUM(zip_codes.population * egrid_regions.loss_factor) / SUM(zip_codes.population)
      #     FROM zip_codes
      #     INNER JOIN egrid_subregions ON egrid_subregions.abbreviation = zip_codes.egrid_subregion_abbreviation
      #     INNER JOIN egrid_regions ON egrid_regions.name = egrid_subregions.egrid_region_name
      #     WHERE zip_codes.state_postal_abbreviation = states.postal_abbreviation
      #   )
      # }
    end
    
    # TODO import this from US census? would be slightly different: 0.7% for Alaska, 0.2% for New Mexico, etc.
    process 'derive population from zip code data' do
      safe_find_each do |state|
        state.update_attributes! :population => state.zip_codes.sum(:population)
      end
      
      # Same this using SQL
      # update_all "population = (SELECT SUM(population) FROM zip_codes WHERE zip_codes.state_postal_abbreviation = states.postal_abbreviation)"
    end
  end
end
