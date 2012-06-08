AutomobileSizeClass.class_eval do
  data_miner do
    process "Start from scratch" do
      delete_all
    end
    
    import "pre-calculated size class data derived from the 2010 EPA Fuel Economy Trends report",
           :url => "file://#{Earth::DATA_DIR}/automobile/sizes.csv" do
      key   :name
      store :type_name
      store :fuel_efficiency_city
      store :fuel_efficiency_city_units
      store :fuel_efficiency_highway
      store :fuel_efficiency_highway_units
    end
    
    import "pre-calculated fuel efficiency multipliers",
           :url => "file://#{Earth::DATA_DIR}/automobile/hybridity_multipliers.csv" do
      key :name
      store :hybrid_fuel_efficiency_city_multiplier
      store :hybrid_fuel_efficiency_highway_multiplier
      store :conventional_fuel_efficiency_city_multiplier
      store :conventional_fuel_efficiency_highway_multiplier
    end
  end
end
