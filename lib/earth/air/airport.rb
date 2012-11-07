require 'earth/model'
require 'earth/loader'

require 'earth/locality/country'
require 'earth/air/flight_segment'

require 'geocoder'

class Airport < ActiveRecord::Base
  extend Earth::Model
  extend Geocoder::Model::ActiveRecord
  Geocoder::Configuration.units = :km

  TABLE_STRUCTURE = <<-EOS

CREATE TABLE airports
  (
     iata_code             CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     name                  CHARACTER VARYING(255),
     city                  CHARACTER VARYING(255),
     country_name          CHARACTER VARYING(255),
     country_iso_3166_code CHARACTER VARYING(255),
     latitude              FLOAT,
     longitude             FLOAT
  );

EOS
  
  self.primary_key = "iata_code"
  
  belongs_to :country,
    :foreign_key => 'country_iso_3166_code',
    :primary_key => 'iso_3166_code'
  has_many :departing_flight_segments, # FIXME TODO consider replacing with a method that also matches ICAO segments by city
    :class_name => 'FlightSegment',
    :foreign_key => :origin_airport_iata_code
  has_many :arriving_flight_segments, # FIXME TODO consider replacing with a method that also matches ICAO segments by city
    :class_name => 'FlightSegment',
    :foreign_key => :destination_airport_iata_code

  reverse_geocoded_by :latitude, :longitude
  
  warn_unless_size 5325
end
