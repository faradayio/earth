AutomobileFuel.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      string 'code'
      string 'base_fuel_name'
      string 'blend_fuel_name'
      float  'blend_portion' # the portion of the blend that is the blend fuel
      string 'distance_key' # used to look up annual distance from AutomobileTypeFuelYear
      string 'ef_key' # used to look up ch4 n2o and hfc emission factors from AutomobileTypeFuelYear
      float  'annual_distance'
      string 'annual_distance_units'
      float  'co2_emission_factor'
      string 'co2_emission_factor_units'
      float  'co2_biogenic_emission_factor'
      string 'co2_biogenic_emission_factor_units'
      float  'ch4_emission_factor'
      string 'ch4_emission_factor_units'
      float  'n2o_emission_factor'
      string 'n2o_emission_factor_units'
      float  'hfc_emission_factor'
      string 'hfc_emission_factor_units'
      float  'emission_factor' # DEPRECATED but motorcycle needs this
      string 'emission_factor_units' # DEPRECATED but motorcycle needs this
    end
    
    import "a list of pure automobile fuels",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdE9xTEdueFM2R0diNTgxUlk1QXFSb2c&output=csv' do
      key   'name'
      store 'code'
      store 'base_fuel_name'
      store 'distance_key'
      store 'ef_key'
    end
    
    import "a list of blended automobile fuels",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdEswNGIxM0U4U0N1UUppdWw2ejJEX0E&output=csv' do
      key   'name'
      store 'code'
      store 'base_fuel_name'
      store 'blend_fuel_name'
      store 'blend_portion'
      store 'distance_key'
      store 'ef_key'
    end
    
    process "Ensure necessary datasets are imported" do
      AutomobileTypeFuelYearAge.run_data_miner!
      AutomobileTypeYear.run_data_miner!
      Fuel.run_data_miner!
      GreenhouseGas.run_data_miner!
    end
    
    process "Derive annual distance" do
      AutomobileFuel.all.each do |record|
        scope = record.type_fuel_year_ages.where(:year => record.type_fuel_year_ages.maximum('year'))
        record.annual_distance = scope.weighted_average(:annual_distance, :weighted_by => :vehicles)
        record.annual_distance_units = scope.first.annual_distance_units
        record.save
      end
    end
    
    process "Derive co2 emission factor and co2 biogenic emission factors" do
      AutomobileFuel.all.each do |record|
        if record.blend_fuel.present?
          record.co2_emission_factor = (record.base_fuel.co2_emission_factor * (1 - record.blend_portion)) + (record.blend_fuel.co2_emission_factor * record.blend_portion)
          record.co2_biogenic_emission_factor = (record.base_fuel.co2_biogenic_emission_factor * (1 - record.blend_portion)) + (record.blend_fuel.co2_biogenic_emission_factor * record.blend_portion)
        else
          record.co2_emission_factor = record.base_fuel.co2_emission_factor
          record.co2_biogenic_emission_factor = record.base_fuel.co2_biogenic_emission_factor
        end
        record.co2_emission_factor_units = record.base_fuel.co2_emission_factor_units
        record.co2_biogenic_emission_factor_units = record.base_fuel.co2_biogenic_emission_factor_units
        record.save
      end
    end
    
    process "Derive ch4, n2o, and hfc emission factors" do
      AutomobileFuel.all.each do |record|
        scope = record.type_fuel_years.where(:year => record.type_fuel_years.maximum('year'))
        
        record.ch4_emission_factor = scope.weighted_average(:ch4_emission_factor, :weighted_by => :total_travel) * GreenhouseGas[:ch4].global_warming_potential
        ch4_prefix = scope.first.ch4_emission_factor_units.split("_per_")[0]
        ch4_suffix = scope.first.ch4_emission_factor_units.split("_per_")[1]
        record.ch4_emission_factor_units = ch4_prefix + "_co2e_per_" + ch4_suffix
        
        record.n2o_emission_factor = scope.weighted_average(:n2o_emission_factor, :weighted_by => :total_travel) * GreenhouseGas[:n2o].global_warming_potential
        n2o_prefix = scope.first.n2o_emission_factor_units.split("_per_")[0]
        n2o_suffix = scope.first.n2o_emission_factor_units.split("_per_")[1]
        record.n2o_emission_factor_units = n2o_prefix + "_co2e_per_" + n2o_suffix
        
        record.hfc_emission_factor = scope.map do |tfy|
          tfy.total_travel * tfy.type_year.hfc_emission_factor
        end.sum / scope.sum('total_travel')
        record.hfc_emission_factor_units = scope.first.type_year.hfc_emission_factor_units
        
        record.save
      end
    end
    
    process "Derive emission factor" do
      update_all "emission_factor = co2_emission_factor + ch4_emission_factor + n2o_emission_factor,
                  emission_factor_units = 'kilograms_co2e_per_litre'"
    end
    
    # FIXME TODO verify code somehow
    
    %w{ base_fuel_name distance_key ef_key }.each do |attribute|
      verify "#{attribute.humanize} should never be missing" do
        AutomobileFuel.all.each do |fuel|
          value = fuel.send(:"#{attribute}")
          unless value.present?
            puts "Missing #{attribute.humanize.downcase} for AutomobileFuel #{fuel.name}"
            raise "Missing #{attribute.humanize.downcase} for AutomobileFuel #{fuel.name}"
          end
        end
      end
    end
    
    # FIXME TODO verify that base_fuel_name and blend_fuel_name are found in Fuel if present
    # FIXME TODO verify that distance_key is found in AutomobileTypeFuelYearAge
    # FIXME TODO verify that ef_key is found in AutomobileTypeFuelYear
    
    verify "Blend portion should be from 0 to 1 if present" do
      AutomobileFuel.all.each do |fuel|
        if fuel.blend_portion.present?
          unless fuel.blend_portion >=0 and fuel.blend_portion <= 1
            puts "Invalid blend portion for AutomobileFuel #{fuel.name}: #{fuel.blend_portion} (should be from 0 to 1)"
            raise "Invalid blend portion for AutomobileFuel #{fuel.name}: #{fuel.blend_portion} (should be from 0 to 1)"
          end
        end
      end
    end
    
    ["co2_emission_factor", "co2_biogenic_emission_factor"].each do |attribute|
      verify "#{attribute.humanize} should be 0 or more" do
        AutomobileFuel.all.each do |fuel|
          value = fuel.send(attribute)
          unless value >= 0
            puts "Invalid #{attribute.humanize.downcase} for AutomobileFuel #{fuel.name}: #{value} (should be 0 or more)"
            raise "Invalid #{attribute.humanize.downcase} for AutomobileFuel #{fuel.name}: #{value} (should be 0 or more)"
          end
        end
      end
    end
    
    ["ch4_emission_factor", "n2o_emission_factor", "hfc_emission_factor"].each do |attribute|
      verify "#{attribute.humanize} should be > 0" do
        AutomobileFuel.all.each do |fuel|
          value = fuel.send(attribute)
          unless value > 0
            puts "Invalid #{attribute.humanize.downcase} for AutomobileFuel #{fuel.name}: #{value} (should be > 0)"
            raise "Invalid #{attribute.humanize.downcase} for AutomobileFuel #{fuel.name}: #{value} (should be > 0)"
          end
        end
      end
    end
    
    [["co2_emission_factor_units", "kilograms_per_litre"],
     ["co2_biogenic_emission_factor_units", "kilograms_per_litre"],
     ["ch4_emission_factor_units", "kilograms_co2e_per_litre"],
     ["n2o_emission_factor_units", "kilograms_co2e_per_litre"],
     ["hfc_emission_factor_units", "kilograms_co2e_per_litre"]].each do |pair|
      attribute = pair[0]
      proper_units = pair[1]
      verify "#{attribute.humanize} should be #{proper_units.humanize.downcase}" do
        AutomobileFuel.all.each do |fuel|
          units = fuel.send(attribute)
          unless units == proper_units
            puts "Invalid #{attribute.humanize.downcase} for AutomobileFuel #{fuel.name}: #{units} (should be #{proper_units})"
            fail
          end
        end
      end
    end
  end
end
