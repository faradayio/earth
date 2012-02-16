class FlightDistanceClassSeatClass < ActiveRecord::Base
  self.primary_key = "name"
  
  belongs_to :seat_class, :class_name => 'FlightSeatClass', :foreign_key => 'seat_class_name'
  belongs_to :distance_class, :class_name => 'FlightDistanceClass', :foreign_key => 'distance_class_name'
  
  falls_back_on :name => 'fallback',
                :multiplier => 1.0
  
  col :name
  col :distance_class_name
  col :seat_class_name
  col :multiplier, :type => :float
end
