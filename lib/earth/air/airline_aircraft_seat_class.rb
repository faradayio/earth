class AirlineAircraftSeatClass < ActiveRecord::Base
  set_primary_key :row_hash
  
  force_schema do
    string  'row_hash'
    string  'airline_name'
    string  'aircraft_description'
    string  'seat_class_name'
    integer 'seats'
    float   'seat_pitch'
    string  'seat_pitch_units'
    float   'seat_width'
    string  'seat_width_units'
  end
end
