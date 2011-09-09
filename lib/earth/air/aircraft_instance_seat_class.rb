class AircraftInstanceSeatClass < ActiveRecord::Base
  set_primary_key :row_hash
  
  force_schema do
    string  'row_hash'
    string  'seat_class_name'
    string  'aircraft_instance_id'
    integer 'seats'
    float   'seat_pitch'
    string  'seat_pitch_units'
    float   'seat_width'
    string  'seat_width_units'
  end
end
