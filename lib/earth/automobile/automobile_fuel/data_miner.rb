AutomobileFuel.class_eval do
  data_miner do
    import "a list of pure automobile fuels",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdE9xTEdueFM2R0diNTgxUlk1QXFSb2c&gid=0&output=csv' do
      key   'name'
      store 'code'
      store 'base_fuel_name'
      store 'distance_key'
      store 'ef_key'
    end
    
    import "a list of blended automobile fuels",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdEswNGIxM0U4U0N1UUppdWw2ejJEX0E&gid=0&output=csv' do
      key   'name'
      store 'code'
      store 'base_fuel_name'
      store 'blend_fuel_name'
      store 'blend_portion'
      store 'distance_key'
      store 'ef_key'
    end
    
    process "Ensure AutomobileTypeFuelYearAge, AutomobileTypeYear, Fuel, and GreenhouseGas are populated" do
      AutomobileTypeFuelYearAge.run_data_miner!
      AutomobileTypeYear.run_data_miner!
      Fuel.run_data_miner!
      GreenhouseGas.run_data_miner!
    end
    
    process "Derive annual distance" do
      find_each do |record|
        scope = record.type_fuel_year_ages.where(:year => record.type_fuel_year_ages.maximum('year'))
        record.annual_distance = scope.weighted_average(:annual_distance, :weighted_by => :vehicles)
        record.annual_distance_units = scope.first.annual_distance_units
        record.save!
      end
    end
    
    process "Derive energy content" do
      find_each do |record|
        if record.blend_fuel.present?
          record.energy_content = (record.base_fuel.energy_content * (1 - record.blend_portion)) + (record.blend_fuel.energy_content * record.blend_portion)
        else
          record.energy_content = record.base_fuel.energy_content
        end
        record.energy_content_units = record.base_fuel.energy_content_units
        record.save!
      end
    end
    
    process "Derive co2 emission factor and co2 biogenic emission factors" do
      find_each do |record|
        if record.blend_fuel.present?
          record.co2_emission_factor = (record.base_fuel.co2_emission_factor.to_f * (1 - record.blend_portion)) + (record.blend_fuel.co2_emission_factor.to_f * record.blend_portion)
          record.co2_biogenic_emission_factor = (record.base_fuel.co2_biogenic_emission_factor.to_f * (1 - record.blend_portion)) + (record.blend_fuel.co2_biogenic_emission_factor.to_f * record.blend_portion)
        else
          record.co2_emission_factor = record.base_fuel.co2_emission_factor
          record.co2_biogenic_emission_factor = record.base_fuel.co2_biogenic_emission_factor
        end
        record.co2_emission_factor_units = record.base_fuel.co2_emission_factor_units
        record.co2_biogenic_emission_factor_units = record.base_fuel.co2_biogenic_emission_factor_units
        record.save!
      end
    end
    
    process "Derive ch4, n2o, and hfc emission factors" do
      find_each do |record|
        scope = record.type_fuel_years.where(:year => record.type_fuel_years.maximum('year'))
        
        record.ch4_emission_factor = scope.weighted_average(:ch4_emission_factor, :weighted_by => :total_travel).to_f * GreenhouseGas[:ch4].global_warming_potential
        ch4_prefix = scope.first.ch4_emission_factor_units.split("_per_")[0]
        ch4_suffix = scope.first.ch4_emission_factor_units.split("_per_")[1]
        record.ch4_emission_factor_units = ch4_prefix + "_co2e_per_" + ch4_suffix
        
        record.n2o_emission_factor = scope.weighted_average(:n2o_emission_factor, :weighted_by => :total_travel).to_f * GreenhouseGas[:n2o].global_warming_potential
        n2o_prefix = scope.first.n2o_emission_factor_units.split("_per_")[0]
        n2o_suffix = scope.first.n2o_emission_factor_units.split("_per_")[1]
        record.n2o_emission_factor_units = n2o_prefix + "_co2e_per_" + n2o_suffix
        
        record.hfc_emission_factor = scope.map do |tfy|
          tfy.total_travel.to_f * tfy.type_year.hfc_emission_factor
        end.sum / scope.sum('total_travel')
        record.hfc_emission_factor_units = scope.first.type_year.hfc_emission_factor_units
        
        record.save!
      end
    end
    
    # FIXME TODO DEPRECATED motorcycle needs this
    process "Derive emission factor" do
      update_all(%{
        emission_factor = 1.0 * co2_emission_factor + ch4_emission_factor + n2o_emission_factor + hfc_emission_factor,
        emission_factor_units = 'kilograms_co2e_per_litre'
      })
    end
    
    # FIXME TODO verify code somehow
  end
end
