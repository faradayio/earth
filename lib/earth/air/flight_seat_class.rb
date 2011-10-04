class FlightSeatClass < ActiveRecord::Base
  set_primary_key :name
  
  has_many :distance_class_seat_classes, :foreign_key => 'seat_class_name', :primary_key => 'name', :class_name => 'FlightDistanceClassSeatClass'
  
  falls_back_on :name => 'fallback',
                :multiplier => 1
  
  col :name
  col :multiplier, :type => :float
end
