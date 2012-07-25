require 'earth/fuel/data_miner'

AutomobileFuel.class_eval do
  data_miner do
    process "Start from scratch" do
      delete_all
    end
    
    import "a Brighter Planet-curated list of automobile fuels",
           :url => "file://#{Earth::DATA_DIR}/automobile/auto_fuel_data.csv" do
      key   'name'
      store 'code'
      store 'family'
      store 'distance_key'
      store 'base_fuel_name', :nullify => true
      store 'blend_fuel_name', :nullify => true
      store 'blend_portion', :nullify => true
    end
    
    process "Ensure Fuel is populated" do
      Fuel.run_data_miner!
    end
    
    process "Derive energy content and co2 emission factors from Fuel" do
      AutomobileFuel.find('electricity').update_attributes!(
        :energy_content => 1.kilowatt_hours.to(:megajoules),
        :energy_content_units => 'megajoules_per_kilowatt_hour'
      )
      
      where("name != 'electricity'").each do |auto_fuel|
        %w{ energy_content co2_emission_factor co2_biogenic_emission_factor }.each do |method|
          value = if auto_fuel.blend_portion
            (auto_fuel.blend_portion * auto_fuel.blend_fuel.send(method)) + ((1 - auto_fuel.blend_portion) * auto_fuel.base_fuel.send(method))
          else
            auto_fuel.base_fuel.send method
          end
          
          auto_fuel.update_attributes!(
            "#{method}" => value,
            "#{method}_units" => auto_fuel.base_fuel.send("#{method}_units")
          )
        end
      end
    end
    
    import "Alternative fuel ch4 and n2o emission factors derived from the EPA GHG inventory",
           :url => "file://#{Earth::DATA_DIR}/automobile/auto_fuel_efs.csv" do
      key 'name'
      store 'ch4_emission_factor', :from_units => :grams_per_mile, :to_units => :kilograms_per_kilometre
      store 'n2o_emission_factor', :from_units => :grams_per_mile, :to_units => :kilograms_per_kilometre
    end
    
    process "Ensure AutomobileTypeFuel is populated" do
      AutomobileTypeFuel.run_data_miner!
    end
    
    process "Derive annual distance, emission factors, and total consumption from AutomobileTypeFuel" do
      safe_find_each do |record|
        if (type_fuels = record.type_fuels).any?
          %w{ annual_distance ch4_emission_factor n2o_emission_factor }.each do |item|
            record.update_attributes!(
              "#{item}" => type_fuels.weighted_average(item, :weighted_by => :vehicles),
              "#{item}_units" => type_fuels.first.send("#{item}_units")
            )
          end
          unless record.name =~ / gasoline/
            record.update_attributes!(
              :total_consumption => record.type_fuels.sum(:fuel_consumption),
              :total_consumption_units => record.type_fuels.first.fuel_consumption_units
            )
          end
        end
      end
    end
    
    process "Derive annual distance for alternative fuels" do
      %w{ diesel gasoline }.each do |key|
        reference_fuel = find(key)
        where(:annual_distance => nil, :distance_key => key).update_all %{
          annual_distance = #{reference_fuel.annual_distance},
          annual_distance_units = '#{reference_fuel.annual_distance_units}'
        }
      end
    end
    
    process "Ensure GreenhouseGas is populated" do
      GreenhouseGas.run_data_miner!
    end
    
    process "Convert emission factors to co2e" do
      %w{ ch4 n2o }.each do |gas|
        where("#{gas}_emission_factor_units = 'kilograms_per_kilometre'").update_all %{
          #{gas}_emission_factor = #{gas}_emission_factor * #{GreenhouseGas[gas].global_warming_potential},
          #{gas}_emission_factor_units = 'kilograms_co2e_per_kilometre'
        }
      end
    end
  end
end
