class ZipCode < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :egrid_subregion, :foreign_key => 'egrid_subregion_abbreviation'
  belongs_to :climate_division, :foreign_key => 'climate_division_name'
  belongs_to :state, :foreign_key => 'state_postal_abbreviation'
#  has_one :census_division, :through => :state
#  has_one :census_region, :through => :state
  
  acts_as_mappable :default_units => :miles,  # FIXME imperial
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  force_schema do
    string   'name'
    string   'state_postal_abbreviation'
    string   'description'
    string   'latitude'
    string   'longitude'
    string   'egrid_subregion_abbreviation'
    string   'climate_division_name'
  end
end
