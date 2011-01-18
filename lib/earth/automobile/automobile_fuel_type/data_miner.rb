AutomobileFuelType.class_eval do
  data_miner do
    schema Earth.database_options do
      string   'code'
      string   'name'
      string   'fuel_common_name'
      float    'emission_factor'
      string   'emission_factor_units'
      float    'annual_distance'
      string   'annual_distance_units'
    end
    
    import "a pre-calculated emission factor and average annual distance for each fuel",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdDlqeU9vQkVkNG1NZXV4WklKTjJkU3c&hl=en&single=true&gid=0&output=csv' do
      key   'code'
      store 'name'
      store 'fuel_common_name'
      store 'emission_factor', :units_field_name => 'emission_factor_units'
    end
    
    process "Calculate annual distance from AutomobileTypeFuelAge" do
      AutomobileTypeFuelAge.run_data_miner!
      ages = AutomobileTypeFuelAge.arel_table
      types = AutomobileFuelType.arel_table
      conditional_relation = ages[:fuel_common_name].eq(types[:fuel_common_name])
      update_all "annual_distance = (#{AutomobileTypeFuelAge.weighted_average_relation(:annual_distance, :weighted_by => :vehicles).where(conditional_relation).to_sql})"
      update_all "annual_distance_units = 'kilometres'"
    end
    
    verify "Annual distance should be greater than zero" do
      AutomobileFuelType.all.each do |fuel_type|
        unless fuel_type.annual_distance > 0.0
          raise "Invalid annual_distance for AutomobileFuelType #{fuel_type.name}: #{fuel_type.annual_distance} (should be > 0)"
        end
      end
    end
    
    verify "Annual distance units should never be missing" do
      AutomobileFuelType.all.each do |fuel_type|
        if fuel_type.annual_distance_units.nil?
          raise "Missing annual distance units for AutomobileFuelType #{fuel_type.name}"
        end
      end
    end
    
    verify "Emission factor should be zero or more" do
      AutomobileFuelType.all.each do |fuel_type|
        unless fuel_type.emission_factor >= 0.0
          raise "Invalid emission_factor for AutomobileFuelType #{fuel_type.name}: #{fuel_type.emission_factor} (should be >= 0)"
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
