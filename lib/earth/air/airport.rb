require ::File.join(Earth::VENDOR_DIR, 'geokit-rails', 'lib', 'geokit-rails')
require 'earth/locality'

class Airport < ActiveRecord::Base
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

  col :iata_code
  col :name
  col :city
  col :country_name
  col :country_iso_3166_code
  col :latitude, :type => :float
  col :longitude, :type => :float

  warn_unless_size 5324
end
