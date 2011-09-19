class AircraftInstanceSeatClass < ActiveRecord::Base
  set_primary_key :row_hash
  
  col :row_hash
  col :seat_class_name
  col :aircraft_instance_id
  col :seats, :type => :integer
  col :seat_pitch, :type => :float
  col :seat_pitch_units
  col :seat_width, :type => :float
  col :seat_width_units
end