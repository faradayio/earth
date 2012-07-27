require 'earth/model'
require 'earth/loader'
Earth::Loader.load_plugins

require 'earth/locality/country'
require 'earth/air/flight_segment'

class Airport < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "airports"
  (
     "iata_code"             CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "name"                  CHARACTER VARYING(255),
     "city"                  CHARACTER VARYING(255),
     "country_name"          CHARACTER VARYING(255),
     "country_iso_3166_code" CHARACTER VARYING(255),
     "latitude"              FLOAT,
     "longitude"             FLOAT
  );
EOS

  self.primary_key = "iata_code"
  
  belongs_to :country,
    :foreign_key => 'country_iso_3166_code',
    :primary_key => 'iso_3166_code'
  has_many :departing_flight_segments,
    :class_name => 'FlightSegment',
    :foreign_key => :origin_airport_iata_code
  has_many :arriving_flight_segments,
    :class_name => 'FlightSegment',
    :foreign_key => :destination_airport_iata_code
  
  acts_as_mappable :default_units => :nms,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude


  warn_unless_size 5324
end
