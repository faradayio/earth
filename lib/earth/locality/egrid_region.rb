require 'earth/locality/egrid_country'

class EgridRegion < ActiveRecord::Base
  self.primary_key = "name"
  
  # EgridCountry must be a parent so that it automatically gets data_mined (needed for fallback calculation)
  belongs_to :egrid_country, :foreign_key => 'country_name'
  has_many :egrid_subregions, :foreign_key => 'egrid_region_name'
  
  falls_back_on :name => 'fallback',
                :loss_factor => lambda { EgridCountry.us.loss_factor }
  
  col :name
  col :generation, :type => :float
  col :generation_units
  col :foreign_interchange, :type => :float
  col :foreign_interchange_units
  col :domestic_interchange, :type => :float
  col :domestic_interchange_units
  col :consumption, :type => :float
  col :consumption_units
  col :loss_factor, :type => :float
  
  warn_unless_size 5
  warn_if_any_nulls
end
