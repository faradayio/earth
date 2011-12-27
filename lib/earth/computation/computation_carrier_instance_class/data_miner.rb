require 'earth/locality/data_miner'
ComputationCarrierInstanceClass.class_eval do
  data_miner do
    import "a list of computation carrier instance classes and their characteristics",
           :url => 'https://spreadsheets.google.com/pub?key=0AkCJNpm9Ks6JdGExaW1ic2c0d2s1ZmpzeUdOa2kyRlE&gid=0&output=csv' do
      key   'name'
      store 'computation_carrier_name'
      store 'instance_class'
      store 'electricity_intensity', :units_field_name => 'electricity_intensity_units'
    end
  end
end
