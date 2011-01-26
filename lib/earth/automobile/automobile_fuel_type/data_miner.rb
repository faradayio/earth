AutomobileFuelType.class_eval do
  data_miner do
    schema Earth.database_options do
      string   'code'
      string   'name'
      string   'fuel_name_for_distance'
      string   'fuel_name_for_efs'
      float    'blend_portion'
      float    'emission_factor'
      string   'emission_factor_units'
      float    'annual_distance'
      string   'annual_distance_units'
    end
    
    import "a list of fuel type codes and attributes",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdDlqeU9vQkVkNG1NZXV4WklKTjJkU3c&hl=en&single=true&gid=0&output=csv' do
      key   'code'
      store 'name'
      store 'fuel_name_for_distance'
      store 'fuel_name_for_efs'
      store 'blend_portion'
    end
    
    process "Calculate annual distance from AutomobileTypeFuelAge" do
      AutomobileTypeFuelAge.run_data_miner!
      ages = AutomobileTypeFuelAge.arel_table
      types = AutomobileFuelType.arel_table
      conditional_relation = ages[:fuel_common_name].eq(types[:fuel_name_for_distance])
      update_all "annual_distance = (#{AutomobileTypeFuelAge.weighted_average_relation(:annual_distance, :weighted_by => :vehicles).where(conditional_relation).to_sql})"
      update_all "annual_distance_units = 'kilometres'"
    end
    
    process "Calculate emission factor from FuelYear, AutomobileTypeFuelYear, and GreenhouseGas" do
      FuelYear.run_data_miner!
      AutomobileTypeFuelYear.run_data_miner!
      GreenhouseGas.run_data_miner!
      
      co2_gwp = GreenhouseGas.find_by_abbreviation("co2").global_warming_potential
      ch4_gwp = GreenhouseGas.find_by_abbreviation("ch4").global_warming_potential
      n2o_gwp = GreenhouseGas.find_by_abbreviation("n2o").global_warming_potential
      
      latest_year = FuelYear.all.collect{|x| x.year }.max
      
      fuel_years = FuelYear.arel_table
      type_fuel_years = AutomobileTypeFuelYear.arel_table
      fuel_types = AutomobileFuelType.arel_table
      
      AutomobileFuelType.all.each do |fuel_type|
        current_name = fuel_type.fuel_name_for_efs
        
        if current_name.present?
          co2_factor_sql = fuel_years.project(fuel_years[:co2_emission_factor]).where(fuel_years[:fuel_common_name].eq(fuel_types[:fuel_name_for_efs]).and(fuel_years[:year].eq(latest_year))).to_sql
          ch4_factor_sql = AutomobileTypeFuelYear.weighted_average_relation(:ch4_emission_factor, :weighted_by => :total_travel).where(type_fuel_years[:fuel_common_name].eq(fuel_types[:fuel_name_for_efs]).and(type_fuel_years[:year].eq(latest_year))).to_sql
          n2o_factor_sql = AutomobileTypeFuelYear.weighted_average_relation(:n2o_emission_factor, :weighted_by => :total_travel).where(type_fuel_years[:fuel_common_name].eq(fuel_types[:fuel_name_for_efs]).and(type_fuel_years[:year].eq(latest_year))).to_sql
          hfc_factor_sql = AutomobileTypeFuelYear.weighted_average_relation(:hfc_emission_factor, :weighted_by => :total_travel).where(type_fuel_years[:fuel_common_name].eq(fuel_types[:fuel_name_for_efs]).and(type_fuel_years[:year].eq(latest_year))).to_sql
          
          connection.execute %{
            UPDATE automobile_fuel_types
            SET emission_factor = (((#{co2_factor_sql}) * #{co2_gwp} * (1 - blend_portion)) + ((#{ch4_factor_sql}) * #{ch4_gwp}) + ((#{n2o_factor_sql}) * #{n2o_gwp}) + (#{hfc_factor_sql}))
            WHERE automobile_fuel_types.fuel_name_for_efs = '#{current_name}'
          }
          connection.execute %{
            UPDATE automobile_fuel_types
            SET emission_factor_units = 'kilograms_co2e_per_litre'
            WHERE automobile_fuel_types.fuel_name_for_efs = '#{current_name}'
          }
        end
      end
    end
    
    process "Calculate emission factor for electricity from EgridSubregion and EgridRegion" do
      EgridSubregion.run_data_miner!
      EgridRegion.run_data_miner!
      electricity_ef = (EgridSubregion.find_by_abbreviation("US").electricity_emission_factor / (1 - EgridRegion.find_by_name("US").loss_factor))
      connection.execute %{
        UPDATE automobile_fuel_types
        SET emission_factor = #{electricity_ef}
        WHERE automobile_fuel_types.name = 'electricity'
      }
    end
    
    verify "Annual distance and emission factor should be greater than zero" do
      AutomobileFuelType.all.each do |fuel_type|
        %w{ annual_distance emission_factor }.each do |attribute|
          value = fuel_type.send(:"#{attribute}")
          unless value > 0
            raise "Invalid #{attribute} for AutomobileFuelType #{fuel_type.name}: #{value} (should be > 0)"
          end
        end
      end
    end
    
    verify "Annual distance units should be kilometres" do
      AutomobileFuelType.all.each do |fuel_type|
        unless fuel_type.annual_distance_units == "kilometres"
          raise "Missing annual distance units for AutomobileFuelType #{fuel_type.name}"
        end
      end
    end
    
    verify "Emission factor units should never be missing" do
      AutomobileFuelType.all.each do |fuel_type|
        if fuel_type.emission_factor_units.nil?
          raise "Missing emission factor units for AutomobileFuelType #{fuel_type.name}"
        end
      end
    end
  end
end
