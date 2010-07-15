class FlightSeatClass < ActiveRecord::Base
  set_primary_key :name
#  has_many :airline_seat_classes, :class_name => 'AirlineSeatClass'
#  has_many :aircraft_seat_classes, :class_name => 'AircraftSeatClass'
#  has_many :airline_aircraft_seat_classes, :class_name => 'AirlineAircraftSeatClass'
  
  falls_back_on :multiplier => 1

  data_miner do
    tap "Brighter Planet's sanitized flight seat class data", Earth.taps_server
  end
end
