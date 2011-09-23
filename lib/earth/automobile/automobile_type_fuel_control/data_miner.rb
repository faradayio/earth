AutomobileTypeFuelControl.class_eval do
  data_miner do
    import "automobile type fuel control data derived from the 2010 EPA GHG Inventory",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdEloSTU5YUNOUXRFRUcxWHlTUi1GMkE&hl=en&gid=0&output=csv' do
      key   'name'
      store 'type_name'
      store 'fuel_common_name'
      store 'control_name'
      store 'ch4_emission_factor', :units_field_name => 'ch4_emission_factor_units'
      store 'n2o_emission_factor', :units_field_name => 'n2o_emission_factor_units'
    end
  end
end
