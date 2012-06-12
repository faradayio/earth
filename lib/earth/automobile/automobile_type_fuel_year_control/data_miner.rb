AutomobileTypeFuelYearControl.class_eval do
  data_miner do
    process "Start from scratch" do
      delete_all
    end
    
    import "automobile type fuel year control data derived from the 2010 EPA GHG Inventory",
           :url => "file://#{Earth::DATA_DIR}/automobile/annual_emission_controls.csv" do
      key   'name'
      store 'type_name'
      store 'fuel_group'
      store 'year'
      store 'control_name'
      store 'type_fuel_control_name', :synthesize => proc { |row| [row['type_name'], row['fuel_group'], row['control_name']].join(' ') }
      store 'total_travel_percent'
    end
  end
end
