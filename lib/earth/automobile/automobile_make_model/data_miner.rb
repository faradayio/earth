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
          [:make_name, :model_name] => :name,
          :make_name => :make_name,
          :model_name => :model_name
        }
      )
    end
    
    # FIXME TODO not weighted until we get weightings on auto variants
    process "Derive average fuel economy from automobile make model year variants" do
      models = arel_table
      variants = AutomobileMakeModelYearVariant.arel_table
      conditional_relation = models[:make_name].eq(variants[:make_name]).and(models[:model_name].eq(variants[:model_name]))
      %w{ city highway }.each do |type|
        null_check = variants[:"fuel_efficiency_#{type}"].not_eq(nil)
        relation = variants.project(variants[:"fuel_efficiency_#{type}"].average).where(conditional_relation).where(null_check)
        update_all(%{
          fuel_efficiency_#{type} = (#{relation.to_sql}),
          fuel_efficiency_#{type}_units = 'kilometres_per_litre'
        })
      end
    end
  end
end
