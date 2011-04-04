AutomobileMakeModelYear.class_eval do
  data_miner do
    process "Start from scratch" do
      connection.drop_table table_name
    end
    
    schema Earth.database_options do
      string   'name' # make + model + year
      string   'make_name'
      string   'model_name'
      string   'make_model_name'
      integer  'year'
      string   'make_year_name'
      float    'fuel_efficiency_city'
      string   'fuel_efficiency_city_units'
      float    'fuel_efficiency_highway'
      string   'fuel_efficiency_highway_units'
    end
    
    process "Derive model year names from automobile make model year variants" do
      AutomobileMakeModelYearVariant.run_data_miner!
      INSERT_IGNORE %{INTO automobile_make_model_years(name, make_name, model_name, make_model_name, year, make_year_name)
        SELECT automobile_make_model_year_variants.make_model_year_name, automobile_make_model_year_variants.make_name, automobile_make_model_year_variants.name, automobile_make_model_year_variants.make_model_name, automobile_make_model_year_variants.year, automobile_make_model_year_variants.make_year_name FROM automobile_make_model_year_variants WHERE LENGTH(automobile_make_model_year_variants.make_name) > 0 AND LENGTH(automobile_make_model_year_variants.make_model_name) > 0
      }
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
        update_all "fuel_efficiency_#{i}_units = 'kilometres_per_litre'"
      end
    end
    
    verify "Year should be from 1985 to 2010" do
      AutomobileMakeModelYear.all.each do |model_year|
        unless model_year.year.to_i > 1984 and model_year.year.to_i < 2011
          raise "Invalid year for AutomobileMakeModelYear #{model_year.name}: #{model_year.year} (should be from 1985 to 2010)"
        end
      end
    end
    
    verify "Fuel efficiencies should be greater than zero" do
      AutomobileMakeModelYear.all.each do |model_year|
        %w{ city highway }.each do |type|
          fuel_efficiency = model_year.send(:"fuel_efficiency_#{type}")
          unless fuel_efficiency.to_f > 0
            raise "Invalid fuel efficiency #{type} for AutomobileMakeModelYear #{model_year.name}: #{fuel_efficiency} (should be > 0)"
          end
        end
      end
    end
    
    verify "Fuel efficiency units should be kilometres per litre" do
      AutomobileMakeModelYear.all.each do |model_year|
        %w{ city highway }.each do |type|
          units = model_year.send(:"fuel_efficiency_#{type}_units")
          unless units == "kilometres_per_litre"
            raise "Invalid fuel efficiency #{type} units for AutomobileMakeModelYear #{model_year.name}: #{units} (should be kilometres_per_litre)"
          end
        end
      end
    end
  end
end
