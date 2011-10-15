AutomobileMakeModelYear.class_eval do
  data_miner do
    process "Start from scratch" do
      delete_all
    end
    
    process "Ensure AutomobileMakeModelYearVariant is populated" do
      AutomobileMakeModelYearVariant.run_data_miner!
    end
    
    process "Derive model year names from automobile make model year variants" do
      ::Earth::Utils.insert_ignore(
        :src => AutomobileMakeModelYearVariant,
        :dest => AutomobileMakeModelYear,
        :cols => {
          [:make_name, :model_name, :year] => :name,
          :make_name => :make_name,
          :model_name => :model_name,
          :year => :year,
        }
      )
    end
    
    # FIXME TODO: weight by volume somehow
    process "Calculate city and highway fuel efficiency from automobile make model year variants" do
      model_years = arel_table
      variants = AutomobileMakeModelYearVariant.arel_table
      conditional_relation = model_years[:make_name].eq(variants[:make_name]).and(model_years[:model_name].eq(variants[:model_name])).and(model_years[:year].eq(variants[:year]))
      %w{ city highway }.each do |i|
        null_check = variants[:"fuel_efficiency_#{i}"].not_eq(nil)
        relation = variants.project(variants[:"fuel_efficiency_#{i}"].average).where(conditional_relation).where(null_check)
        update_all "fuel_efficiency_#{i} = (#{relation.to_sql}), fuel_efficiency_#{i}_units = 'kilometres_per_litre'"
        # update_all "fuel_efficiency_#{i}_units => 'kilometres_per_litre'"
      end
    end
  end
end
