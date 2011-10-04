class FlightDistanceClassSeatClass < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :distance_class, :foreign_key => 'distance_class_name', :primary_key => 'name', :class_name => 'FlightDistanceClass'
  
  col :name
  col :distance_class_name
  col :seat_class_name
  col :multiplier, :type => :float
end