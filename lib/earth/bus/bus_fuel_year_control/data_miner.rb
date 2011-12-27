require 'earth/fuel/data_miner'
BusFuelYearControl.class_eval do
  data_miner do
    process "Ensure BusFuelControl is populated" do
      BusFuelControl.run_data_miner!
    end
    
    import "a list of bus fuel year controls",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdGhHQkZPZW4zbXYzZ3NkYThBWnQ2QXc&gid=0&output=csv' do
      key   'name'
      store 'bus_fuel_name'
      store 'year'
      store 'control'
      store 'total_travel_percent'
    end
    
    process "Derive bus fuel control name for association with BusFuelControl" do
      update_all "bus_fuel_control_name = bus_fuel_name || ' ' || control"
    end
    
    # FIXME TODO verify that for any year the percentages sum to 1
  end
end
