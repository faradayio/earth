FlightSeatClass.class_eval do
  data_miner do
    process "Ensure that FlightDistanceClassSeatClass is populated" do
      FlightDistanceClassSeatClass.run_data_miner!
    end
    
    process "Derive flight seat classes names from FlightDistanceClassSeatClass" do
      FlightDistanceClassSeatClass.select("DISTINCT seat_class_name").each do |distance_class_seat_class|
        FlightSeatClass.find_or_create_by_name(distance_class_seat_class.seat_class_name)
      end
    end
    
    process "Calculate multipliers from FlightDistanceClassSeatClass and FlightDistanceClass" do
      FlightSeatClass.find_each do |seat_class|
        seat_class.multiplier = 
          seat_class.distance_class_seat_classes.map do |dcsc|
            dcsc.multiplier * dcsc.distance_class.passengers
          end.sum / seat_class.distance_class_seat_classes.map(&:distance_class).map(&:passengers).sum
        seat_class.save!
      end
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
