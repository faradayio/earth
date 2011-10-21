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
    
    process "Derive fuel from automobile make model year variants" do
      model_years = arel_table
      variants = AutomobileMakeModelYearVariant.arel_table
      conditional_relation = variants[:make_name].eq(model_years[:make_name]).and(variants[:model_name].eq(model_years[:model_name])).and(variants[:year].eq(model_years[:year]))
      update_all("fuel_code = (#{variants.project('DISTINCT fuel_code').where(conditional_relation).to_sql})",
                 "(#{variants.project('COUNT(DISTINCT fuel_code)').where(conditional_relation).to_sql}) = 1")
    end
    
    # FIXME TODO not in automobile_make_model_year_variants because they're missing from the EPA FEG download files:
    # 2005 Honda Accord Hybrid
    # 2006 Honda Accord Hybrid
    # 2009 Chrysler Aspen HEV
    # 2009 Dodge Durango HEV
    import "A list of hybrid make model years derived from the EPA fuel economy guide",
           :url => 'https://docs.google.com/spreadsheet/pub?hl=en_US&hl=en_US&key=0AoQJbWqPrREqdGtzekE4cGNoRGVmdmZMaTNvOWluSnc&output=csv' do
      key 'name', :synthesize => lambda { |record| [record['make_name'], record['model_name'], record['year']].join(' ') }
      store 'hybridity'
    end
    
    process "Set hybridity to FALSE for all other make model years" do
      update_all({:hybridity => false}, {:hybridity => nil})
    end
    
    # FIXME TODO: weight by volume somehow
    process "Calculate city and highway fuel efficiency from automobile make model year variants" do
      model_years = arel_table
      variants = AutomobileMakeModelYearVariant.arel_table
      conditional_relation = model_years[:make_name].eq(variants[:make_name]).and(model_years[:model_name].eq(variants[:model_name])).and(model_years[:year].eq(variants[:year]))
      %w{ city highway }.each do |type|
        null_check = variants[:"fuel_efficiency_#{type}"].not_eq(nil)
        relation = variants.project(variants[:"fuel_efficiency_#{type}"].average).where(conditional_relation).where(null_check)
        update_all "fuel_efficiency_#{type} = (#{relation.to_sql}), fuel_efficiency_#{type}_units = 'kilometres_per_litre'"
      end
    end
  end
end
