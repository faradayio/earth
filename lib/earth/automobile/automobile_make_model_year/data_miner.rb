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
          :make_model_year_name => :name,
          :make_name => :make_name,
          :name => :model_name,
          :make_model_name => :make_model_name,
          :year => :year,
          :make_year_name => :make_year_name
        }
        # :where => 'LENGTH(src.make_name) > 0 AND LENGTH(src.make_model_name) > 0'
      )
    end
    
    # FIXME TODO make this a method on AutomobileMakeModelYear?
    # TODO: weight by volume somehow
    # note that we used to derive averages from make years, but here we get it from variants
    # even without volume-weighting, the values are much better.
    # for example, 20km/l for a toyota prius 2006 vs. 13km/l if you use make years
    process "Calculate city and highway fuel efficiency from automobile make model year variants" do
      model_years = AutomobileMakeModelYear.arel_table
      variants = AutomobileMakeModelYearVariant.arel_table
      conditional_relation = model_years[:name].eq(variants[:make_model_year_name])
      %w{ city highway }.each do |i|
        null_check = variants[:"fuel_efficiency_#{i}"].not_eq(nil)
        # sabshere 12/6/10 careful, don't use AutomobileMakeModelYearVariant.where here or you will be forced into projecting *
        relation = variants.project(variants[:"fuel_efficiency_#{i}"].average).where(conditional_relation).where(null_check)
        update_all "fuel_efficiency_#{i} = (#{relation.to_sql})"
        update_all "fuel_efficiency_#{i}_units" => 'kilometres_per_litre'
      end
    end
  end
end
