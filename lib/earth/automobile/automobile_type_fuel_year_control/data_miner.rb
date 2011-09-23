AutomobileTypeFuelYearControl.class_eval do
  data_miner do
    import "automobile type fuel year control data derived from the 2010 EPA GHG Inventory",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdGpQV2xMdlZkV1JzVlVTeU5ZalF6elE&hl=en&gid=0&output=csv' do
      key   'name'
      store 'type_name'
      store 'fuel_common_name'
      store 'year'
      store 'control_name'
      store 'total_travel_percent'
    end
    
    process "Derive type fuel control name for association with AutomobileTypeFuelControl" do
      update_all "type_fuel_control_name = type_name || ' ' || fuel_common_name || ' ' || control_name"
    end
    
    process "Derive type fuel year name for association with AutomobileTypeFuelYear" do
      update_all "type_fuel_year_name = type_name || ' ' || fuel_common_name || ' ' || year"
    end
  end
end
