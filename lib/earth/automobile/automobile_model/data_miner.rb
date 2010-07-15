AutomobileModel.class_eval do
  data_miner do
    process "Start from scratch" do
      connection.drop_table table_name
    end
    
    schema :options => 'ENGINE=InnoDB default charset=utf8' do
      string  'name' # make + model
      string  'make_name'
      float   'fuel_efficiency_city'
      string  'fuel_efficiency_city_units'
      float   'fuel_efficiency_highway'
      string  'fuel_efficiency_highway_units'
    end

    process "Derive model names from automobile variants" do
      AutomobileVariant.run_data_miner!
      connection.execute %{
        INSERT IGNORE INTO automobile_models(name, make_name)
        SELECT automobile_variants.model_name, automobile_variants.make_name FROM automobile_variants WHERE LENGTH(automobile_variants.model_name) > 0 AND LENGTH(automobile_variants.make_name) > 0
      }
    end
    
    # TODO not weighted until we get weightings on auto variants
    process "Derive average fuel economy from automobile variants" do
      AutomobileVariant.run_data_miner!
      automobile_models = AutomobileModel.arel_table
      automobile_variants = AutomobileVariant.arel_table
      conditional_relation = automobile_models[:name].eq(automobile_variants[:model_name])
      %w{ city highway }.each do |i|
        relation = AutomobileVariant.where(conditional_relation).where("`automobile_variants`.`fuel_efficiency_#{i}` IS NOT NULL").project("AVG(`automobile_variants`.`fuel_efficiency_#{i}`)")
        update_all "fuel_efficiency_#{i} = (#{relation.to_sql})"
        update_all "fuel_efficiency_#{i}_units = 'kilometres_per_litre'"
      end
    end
  end
end

