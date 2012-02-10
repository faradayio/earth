require ::File.join(Earth.vendor_dir, 'geokit-rails', 'lib', 'geokit-rails')
require 'earth/locality'

class Airport < ActiveRecord::Base
  self.primary_key = "iata_code"
  
  belongs_to :country, :foreign_key => 'country_iso_3166_code', :primary_key => 'iso_3166_code'
  
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
end
