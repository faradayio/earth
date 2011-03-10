ComputationCarrierInstanceClass.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      string 'computation_carrier_name'
      string 'instance_class'
      float  'electricity_intensity'
      string 'electricity_intensity_units'
    end
    
    import "a list of computation carrier instance classes and their characteristics",
           :url => 'https://spreadsheets.google.com/pub?key=0AkCJNpm9Ks6JdGExaW1ic2c0d2s1ZmpzeUdOa2kyRlE&gid=0&output=csv' do
      key   'name'
      store 'computation_carrier_name'
      store 'instance_class'
      store 'electricity_intensity', :units_field_name => 'electricity_intensity_units'
    end
    
    # FIXME TODO verify that computation carrier name appears in computation_carriers
    
    verify "Electricity intensity should be more than zero" do
      ComputationCarrierInstanceClass.all.each do |instance_class|
        unless instance_class.electricity_intensity > 0
          raise "Invalid electricity intensity for ComputationCarrierInstanceClass #{instance_class.name}: #{instance_class.electricity_intensity} (should be > 0)"
        end
      end
    end
    
    verify "Electricity intensity units should be kilowatts" do
      ComputationCarrierInstanceClass.all.each do |instance_class|
        unless instance_class.electricity_intensity_units == 'kilowatts'
          raise "Invalid electricity intensity units for ComputationCarrierInstanceClass #{instance_class.name}: #{instance_class.electricity_intensity_units} (should be kilowatts)"
        end
      end
    end
  end
end
