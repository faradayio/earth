AutomobileMakeModel.class_eval do
  data_miner do
    process "Start from scratch" do
      connection.drop_table table_name
    end
    
    schema Earth.database_options do
      string  'name' # make + model
      string  'make_name'
      string  'model_name' # model only
      float   'fuel_efficiency_city'
      string  'fuel_efficiency_city_units'
      float   'fuel_efficiency_highway'
      string  'fuel_efficiency_highway_units'
    end
    
    process "Derive model names from automobile make model year variants" do
      AutomobileMakeModelYearVariant.run_data_miner!
      INSERT_IGNORE %{INTO automobile_make_models(name, make_name, model_name)
        SELECT automobile_make_model_year_variants.make_model_name, automobile_make_model_year_variants.make_name, automobile_make_model_year_variants.name FROM automobile_make_model_year_variants WHERE LENGTH(automobile_make_model_year_variants.make_name) > 0 AND LENGTH(automobile_make_model_year_variants.name) > 0
      }
    end
    
    # FIXME TODO make this a method on AutomobileMakeModel?
    # TODO not weighted until we get weightings on auto variants
    process "Derive average fuel economy from automobile make model year variants" do
      models = AutomobileMakeModel.arel_table
      variants = AutomobileMakeModelYearVariant.arel_table
      conditional_relation = models[:name].eq(variants[:make_model_name])
      %w{ city highway }.each do |i|
        null_check = variants[:"fuel_efficiency_#{i}"].not_eq(nil)
        # sabshere 12/6/10 careful, don't use AutomobileMakeModelYearVariant.where here or you will be forced into projecting *
        relation = variants.project(variants[:"fuel_efficiency_#{i}"].average).where(conditional_relation).where(null_check)
        update_all "fuel_efficiency_#{i} = (#{relation.to_sql})"
        update_all "fuel_efficiency_#{i}_units = 'kilometres_per_litre'"
      end
    end
    
    verify "Fuel efficiencies should be greater than zero" do
      AutomobileMakeModel.all.each do |model|
        %w{ city highway }.each do |type|
          fuel_efficiency = model.send(:"fuel_efficiency_#{type}")
          unless fuel_efficiency > 0
            raise "Invalid fuel efficiency #{type} for AutomobileMakeModel #{model.name}: #{fuel_efficiency} (should be > 0)"
          end
        end
      end
    end
    
    verify "Fuel efficiency units should be kilometres per litre" do
      AutomobileMakeModel.all.each do |model|
        %w{ city highway }.each do |type|
          units = model.send(:"fuel_efficiency_#{type}_units")
          unless units == "kilometres_per_litre"
            raise "Invalid fuel efficiency #{type} units for AutomobileMakeModel #{model.name}: #{units} (should be kilometres_per_litre)"
          end
        end
      end
    end
  end
end
