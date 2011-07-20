class FlightSeatClass < ActiveRecord::Base
  set_primary_key :name
  
  falls_back_on :multiplier => 1

  force_schema do
    string   'name'
    string   'distance_class_name'
    string   'seat_class_name'
    float    'multiplier'
  end
end
