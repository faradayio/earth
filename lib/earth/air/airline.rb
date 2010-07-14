class Airline < ActiveRecord::Base
  set_primary_key :iata_code

#  has_many :airline_aircraft, :class_name => 'AirlineAircraft'
#  has_many :seat_classes, :class_name => 'AirlineSeatClass'
  has_many :segments, :class_name => "FlightSegment", :foreign_key => 'airline_iata_code'
#  has_many :airline_aircraft_seat_classes, :class_name => 'AirlineAircraftSeatClass'

  index :iata_code
  
  class << self
    def loose_search_columns
      @_loose_search_columns ||= [primary_key, :name]
    end
  
    # search by name
    def loose_right_reader
      @_loose_right_reader ||= lambda { |record| record[1] }
    end
  end
  
  data_miner do
    tap "Brighter Planet's sanitized airlines data", TAPS_SERVER
  end
  
  def all_flights_domestic?
    !international?
  end
end
