class Airline < ActiveRecord::Base
  self.primary_key = "name"
  
  col :name
  col :secondary_name
  col :bts_code
  col :iata_code
  col :icao_code

  warn_unless_size 1523 # note: this is overridden in data1, which imports extra airlines from proprietary data
end
