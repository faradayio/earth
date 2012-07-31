require 'earth/fuel/greenhouse_gas'

AutomobileTypeFuelControl.class_eval do
  data_miner do
    import "automobile type fuel control data derived from the 2010 EPA GHG Inventory",
           :url => "file://#{Earth::DATA_DIR}/automobile/emission_control_techs.csv" do
      key   'name'
      store 'type_name'
      store 'fuel_family'
      store 'control_name'
      store 'ch4_emission_factor', :from_units => :grams_per_mile, :to_units => :kilograms_per_kilometre
      store 'n2o_emission_factor', :from_units => :grams_per_mile, :to_units => :kilograms_per_kilometre
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
