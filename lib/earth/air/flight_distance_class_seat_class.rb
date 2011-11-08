class FlightDistanceClassSeatClass < ActiveRecord::Base
  set_primary_key :name
  
  falls_back_on :name => 'fallback',
                :multiplier => 1.0
  
  col :name
  col :distance_class_name
  col :seat_class_name
  col :multiplier, :type => :float
end
