class FlightSeatClass < ActiveRecord::Base
  set_primary_key :name
  
  falls_back_on :multiplier => 1

  col :name
  col :distance_class_name
  col :seat_class_name
  col :multiplier, :type => :float
end