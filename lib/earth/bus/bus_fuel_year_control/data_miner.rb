BusFuelYearControl.class_eval do
  data_miner do
    schema Earth.database_options do
      string  'name'
      string  'bus_fuel_name'
      integer 'year'
      string  'control'
      string  'bus_fuel_control_name'
      float   'total_travel_percent'
    end
    
    import "a list of bus fuel year controls",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdGhHQkZPZW4zbXYzZ3NkYThBWnQ2QXc&output=csv' do
      key   'name'
      store 'bus_fuel_name'
      store 'year'
      store 'control'
      store 'total_travel_percent'
    end
    
    process "Derive bus fuel control name for association with BusFuelControl" do
      if ActiveRecord::Base.connection.adapter_name.downcase == 'sqlite'
        update_all "bus_fuel_control_name = bus_fuel_name || ' ' || control"
      else
        update_all "bus_fuel_control_name = CONCAT(bus_fuel_name, ' ', control)"
      end
    end
    
    # FIXME TODO verify that for any year the percentages sum to 1
  end
end
