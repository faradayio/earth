AutomobileMakeModelYear.class_eval do
  data_miner do
    process "Start from scratch" do
      connection.drop_table table_name
    end
    
    schema Earth.database_options do
      string   'name'
      string   'make_name'
      string   'make_model_name'
      integer  'year'
      string   'make_year_name'
      float    'fuel_efficiency'
      string   'fuel_efficiency_units'
      float    'fuel_efficiency_city'
      string   'fuel_efficiency_city_units'
      float    'fuel_efficiency_highway'
      string   'fuel_efficiency_highway_units'
    end

    process "Derive model year names from automobile make model year variants" do
      AutomobileMakeModelYearVariant.run_data_miner!
      connection.execute %{
        INSERT IGNORE INTO automobile_make_model_years(name, make_name, make_model_name, year, make_year_name)
        SELECT automobile_make_model_year_variants.make_model_year_name, automobile_make_model_year_variants.make_name, automobile_make_model_year_variants.make_model_name, automobile_make_model_year_variants.year, automobile_make_model_year_variants.make_year_name FROM automobile_make_model_year_variants WHERE LENGTH(automobile_make_model_year_variants.make_name) > 0 AND LENGTH(automobile_make_model_year_variants.make_model_name) > 0
      }
    end
    
    # TODO: weight by volume somehow
    # note that we used to derive averages from make years, but here we get it from variants
    # even without volume-weighting, the values are much better.
    # for example, 20km/l for a toyota prius 2006 vs. 13km/l if you use make years
    process "Calculate city and highway fuel efficiency from automobile make model year variants" do
      AutomobileMakeModelYearVariant.run_data_miner!
      automobile_make_model_years = AutomobileMakeModelYear.arel_table
      automobile_make_model_year_variants = AutomobileMakeModelYearVariant.arel_table
      conditional_relation = automobile_make_model_years[:name].eq(automobile_make_model_year_variants[:make_model_year_name])
      %w{ city highway }.each do |i|
        # sabshere 12/6/10 careful, don't use AutomobileMakeModelYearVariant.where here or you will be forced into projecting *
        relation = automobile_make_model_year_variants.where(conditional_relation).where("`automobile_make_model_year_variants`.`fuel_efficiency_#{i}` IS NOT NULL").project("AVG(`automobile_make_model_year_variants`.`fuel_efficiency_#{i}`)")
        update_all "fuel_efficiency_#{i} = (#{relation.to_sql})"
        update_all "fuel_efficiency_#{i}_units = 'kilometres_per_litre'"
      end
    end
    
    process "Calculate overall fuel efficiency using the latest EPA equation" do
      update_all "fuel_efficiency = 1 / ((0.43 / fuel_efficiency_city) + (0.57 / fuel_efficiency_highway))"
      update_all "fuel_efficiency_units = 'kilometres_per_litre'"
    end
  end
end

