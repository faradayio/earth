class AircraftInstance < ActiveRecord::Base
  self.primary_key = :id
  
  col :id
  col :registration
  col :serial_number
  col :aircraft_description
  col :airline_name
  add_index :registration
  add_index :serial_number
end
