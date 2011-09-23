AutomobileMakeModel.class_eval do
  data_miner do
    process "Start from scratch" do
      delete_all
    end
    
    process "Ensure AutomobileMakeModelYearVariant is populated" do
      AutomobileMakeModelYearVariant.run_data_miner!
    end
    
    process "Derive model names from automobile make model year variants" do
      ::Earth::Utils.insert_ignore(
        :src => AutomobileMakeModelYearVariant,
        :dest => AutomobileMakeModel,
        :cols => {
          :make_model_name => :name,
          :make_name => :make_name,
          :name => :model_name
        }
        # :where => 'LENGTH(src.make_name) > 0 AND LENGTH(src.make_model_name) > 0'
      )
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
  end
end
