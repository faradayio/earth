require ::File.join(Earth::VENDOR_DIR, 'geokit-rails', 'lib', 'geokit-rails') # for acts_as_mappable

class ZipCode < ActiveRecord::Base
  self.primary_key = "name"
  
  belongs_to :egrid_subregion,  :foreign_key => 'egrid_subregion_abbreviation'
  belongs_to :climate_division, :foreign_key => 'climate_division_name'
  belongs_to :state,            :foreign_key => 'state_postal_abbreviation'
  has_many :electric_markets,   :foreign_key => 'zip_code_name'
  has_many :electric_utilities, :through => :electric_markets
  
  def country
    Country.united_states
  end
  
  # Used by LodgingProperty custom find to find properties near to a zip code
  def latitude_longitude
    [latitude, longitude]
  end
  
  # Used by LodgingProperty custom find to find properties near to a zip code
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
  col :population, :type => :integer
  
  warn_unless_size 43770
  warn_if_nonexistent_owner_except :egrid_subregion
end
