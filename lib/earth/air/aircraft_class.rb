class AircraftClass < ActiveRecord::Base
  set_primary_key :aircraft_class_code
  
  has_many :aircraft, :foreign_key => 'aircraft_class_code'
#  has_many :airline_aircraft_seat_classes, :through => :aircraft

  data_miner do
    tap "Brighter Planet's aircraft class data", Earth.taps_server
  end
end
