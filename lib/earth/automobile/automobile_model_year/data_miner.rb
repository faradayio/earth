AutomobileModelYear.class_eval do
  data_miner do
    process "Start from scratch" do
      connection.drop_table table_name
    end
    
    schema Earth.database_options do
      string   'name'
      string   'make_name'
      string   'model_name'
      integer  'year'
      string   'make_year_name'
      float    'fuel_efficiency'
      string   'fuel_efficiency_units'
      float    'fuel_efficiency_city'
      string   'fuel_efficiency_city_units'
      float    'fuel_efficiency_highway'
      string   'fuel_efficiency_highway_units'
    end

    process "Derive model year names from automobile variants" do
      AutomobileVariant.run_data_miner!
      connection.execute %{
        INSERT IGNORE INTO automobile_model_years(name, make_name, model_name, year, make_year_name)
        SELECT automobile_variants.model_year_name, automobile_variants.make_name, automobile_variants.model_name, automobile_variants.year, automobile_variants.make_year_name FROM automobile_variants WHERE LENGTH(automobile_variants.make_name) > 0 AND LENGTH(automobile_variants.model_name) > 0
      }
    end
    
    # TODO: weight by volume somehow
    # note that we used to derive averages from make years, but here we get it from variants
    # even without volume-weighting, the values are much better.
    # for example, 20km/l for a toyota prius 2006 vs. 13km/l if you use make years
    process "Calculate city and highway fuel efficiency from automobile variants" do
      AutomobileVariant.run_data_miner!
      automobile_model_years = AutomobileModelYear.arel_table
      automobile_variants = AutomobileVariant.arel_table
      conditional_relation = automobile_model_years[:name].eq(automobile_variants[:model_year_name])
      %w{ city highway }.each do |i|
        relation = AutomobileVariant.where(conditional_relation).where("`automobile_variants`.`fuel_efficiency_#{i}` IS NOT NULL").project("AVG(`automobile_variants`.`fuel_efficiency_#{i}`)")
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

