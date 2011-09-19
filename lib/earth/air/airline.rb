class Airline < ActiveRecord::Base
  set_primary_key :name
  
  col :name
  col :bts_code
  col :iata_code
  col :icao_code
end