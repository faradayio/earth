require 'falls_back_on'

require 'earth/model'

require 'earth/air/flight_distance_class'
require 'earth/air/flight_seat_class'

class FlightDistanceClassSeatClass < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "flight_distance_class_seat_classes"
  (
     "name"                CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "distance_class_name" CHARACTER VARYING(255),
     "seat_class_name"     CHARACTER VARYING(255),
     "multiplier"          FLOAT
  );
EOS

  self.primary_key = "name"
  
  belongs_to :seat_class, :class_name => 'FlightSeatClass', :foreign_key => 'seat_class_name'
  belongs_to :distance_class, :class_name => 'FlightDistanceClass', :foreign_key => 'distance_class_name'
  
  falls_back_on :name => 'fallback',
                :multiplier => 1.0
  

  warn_unless_size 7
end
