AutomobileMakeModel.class_eval do
  data_miner do
    process "Start from scratch" do
      connection.drop_table table_name
    end
    
    schema Earth.database_options do
      string  'name' # make + model
      string  'make_name'
      float   'fuel_efficiency_city'
      string  'fuel_efficiency_city_units'
      float   'fuel_efficiency_highway'
      string  'fuel_efficiency_highway_units'
    end

    process "Derive model names from automobile make model year variants" do
      AutomobileMakeModelYearVariant.run_data_miner!
      connection.execute %{
        INSERT IGNORE INTO automobile_make_models(name, make_name)
        SELECT automobile_make_model_year_variants.model_name, automobile_make_model_year_variants.make_name FROM automobile_make_model_year_variants WHERE LENGTH(automobile_make_model_year_variants.model_name) > 0 AND LENGTH(automobile_make_model_year_variants.make_name) > 0
      }
    end
    
    # TODO not weighted until we get weightings on auto variants
    process "Derive average fuel economy from automobile make model year variants" do
      AutomobileMakeModelYearVariant.run_data_miner!
      automobile_make_models = AutomobileMakeModel.arel_table
      automobile_make_model_year_variants = AutomobileMakeModelYearVariant.arel_table
      conditional_relation = automobile_make_models[:name].eq(automobile_make_model_year_variants[:model_name])
      %w{ city highway }.each do |i|
        relation = AutomobileMakeModelYearVariant.where(conditional_relation).where("`automobile_make_model_year_variants`.`fuel_efficiency_#{i}` IS NOT NULL").project("AVG(`automobile_make_model_year_variants`.`fuel_efficiency_#{i}`)")
        update_all "fuel_efficiency_#{i} = (#{relation.to_sql})"
        update_all "fuel_efficiency_#{i}_units = 'kilometres_per_litre'"
      end
    end
  end
end

