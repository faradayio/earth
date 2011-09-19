class AircraftInstance < ActiveRecord::Base
  set_primary_key :id
  
  col :id
  col :registration
  col :serial_number
  col :aircraft_description
  col :airline_name
end