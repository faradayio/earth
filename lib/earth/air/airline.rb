class Airline < ActiveRecord::Base
  self.primary_key = "name"
  
  col :name
  col :secondary_name
  col :bts_code
  col :iata_code
  col :icao_code
end
