class EgridRegion < ActiveRecord::Base
  self.primary_key = "name"
  
  # make EgridCountry a parent so that it automatically gets data_mined (need it for fallback calculation)
  belongs_to :egrid_country, :foreign_key => 'country_name'
  has_many :egrid_subregions, :foreign_key => 'egrid_region_name'
  
  falls_back_on :name => 'fallback',
                :loss_factor => lambda { (EgridCountry.us.generation + EgridCountry.us.imports - EgridCountry.us.consumption) / EgridCountry.us.generation }
  
  col :name
  col :country_name
  col :loss_factor, :type => :float

  warn_unless_size 6
  warn_if_blanks_except :country_name, :conditions => { :name => 'US' }
end
