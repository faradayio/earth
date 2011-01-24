FlightSeatClass.class_eval do
  data_miner do
    schema Earth.database_options do
      string   'name'
      float    'multiplier'
    end
    
    import "a list of Brighter Planet-defined seat classes and pre-calculated multipliers",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdG5zSER1QmFVVkhNcTM2cmhCMEJtWVE&hl=en&single=true&gid=0&output=csv' do
      key   'name'
      store 'multiplier'
    end

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
