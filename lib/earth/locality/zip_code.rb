require ::File.join(Earth.vendor_dir, 'geokit-rails', 'lib', 'geokit-rails')

class ZipCode < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :egrid_subregion,  :foreign_key => 'egrid_subregion_abbreviation'
  belongs_to :climate_division, :foreign_key => 'climate_division_name'
  belongs_to :state,            :foreign_key => 'state_postal_abbreviation'
  
  def country
    Country.united_states
  end
  
  def latitude_longitude
    [latitude, longitude]
  end
  
  acts_as_mappable :default_units => :kilometres,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude
  
  col :name
  col :state_postal_abbreviation
  col :description
  col :latitude
  col :longitude
  col :egrid_subregion_abbreviation
  col :climate_division_name
end
