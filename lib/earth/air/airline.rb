class Airline < ActiveRecord::Base
  set_primary_key :iata_code

#  has_many :airline_aircraft, :class_name => 'AirlineAircraft'
#  has_many :seat_classes, :class_name => 'AirlineSeatClass'
#  has_many :segments, :foreign_key => 'airline_iata_code', :primary_key => 'iata_code', :class_name => "FlightSegment"
#  has_many :airline_aircraft_seat_classes, :class_name => 'AirlineAircraftSeatClass'

  data_miner do
    tap "Brighter Planet's sanitized airlines data", Earth.taps_server
  end
  
  def all_flights_domestic?
    !international?
  end
end
