FlightDistanceClassSeatClass.class_eval do
  data_miner do
    import "seat classes used in the WRI GHG Protocol calculation tools",
           :url => 'https://docs.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdG9EdmxybG1wdC1iU3JRYXNkMGhvSnc&output=csv' do
      key   'name'
      store 'distance_class_name'
      store 'seat_class_name'
      store 'multiplier'
    end
    
    # FIXME TODO verify this
  end
end
