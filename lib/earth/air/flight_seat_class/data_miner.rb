FlightSeatClass.class_eval do
  data_miner do
    schema Earth.database_options do
      string   'name'
      string   'distance_class_name'
      string   'seat_class_name'
      float    'multiplier'
    end
    
    import "seat classes used in the WRI GHG Protocol calculation tools",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdG5zSER1QmFVVkhNcTM2cmhCMEJtWVE&hl=en&gid=0&output=csv' do
      key   'name'
      store 'distance_class_name'
      store 'seat_class_name'
      store 'multiplier'
    end
    
    # FIXME TODO verify this
    
    # sabshere 5/21/10 in case we ever need this
    # class << self
    #   def refresh
    #     update_all_weighted_averages(:seats,      :weighted_by => :airline_aircraft_seat_classes)
    #     update_all_weighted_averages(:multiplier, :weighted_by => :airline_aircraft_seat_classes)
    #   end
    # 
    #   def safe_find_by_name(name)
    #     guess = case name.to_s.downcase.gsub(/[^a-z]/, '')
    #     when /first/
    #       'first'
    #     when /busi/, /exec/
    #       'business'
    #     when /econ/, /coach/
    #       'economy'
    #     end
    #     find_or_create_by_name(guess) unless guess.nil?
    #   end
    # end
  end
end
