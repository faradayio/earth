class Airline < ActiveRecord::Base
  self.primary_key = "name"

  has_many :flight_segments,
    :primary_key => :bts_code,
    :foreign_key => :airline_bts_code
  
  col :name
  col :secondary_name
  col :bts_code
  col :iata_code
  col :icao_code

  warn_unless_size 1523 # note: this is overridden in data1, which imports extra airlines from proprietary data
end
