class AircraftInstance < ActiveRecord::Base
  set_primary_key :id
  
  force_schema do
    string 'id'
    string 'registration'
    string 'serial_number'
    string 'aircraft_description'
    string 'airline_name'
  end
end
