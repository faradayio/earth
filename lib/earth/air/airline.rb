require 'earth/model'
require 'earth/air/flight_segment'

class Airline < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "airlines"
  (
     "name"           CHARACTER VARYING(255) NOT NULL,
     "secondary_name" CHARACTER VARYING(255),
     "bts_code"       CHARACTER VARYING(255),
     "iata_code"      CHARACTER VARYING(255),
     "icao_code"      CHARACTER VARYING(255)
  );
ALTER TABLE "airlines" ADD PRIMARY KEY ("name")
EOS

  self.primary_key = "name"

  has_many :flight_segments,
    :primary_key => :bts_code,
    :foreign_key => :airline_bts_code
  

  warn_unless_size 1523 # note: this is overridden in data1, which imports extra airlines from proprietary data
end
