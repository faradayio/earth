class FlightSeatClass < ActiveRecord::Base
  self.primary_key = "name"
  
  col :name

  warn_unless_size 4
end
