class FlightSeatClass < ActiveRecord::Base
  self.primary_key = "name"
  
  col :name
end
