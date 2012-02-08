class EgridRegion < ActiveRecord::Base
  self.primary_key = :name
  
  has_many :egrid_subregions, :foreign_key => 'egrid_region_name'
  
  falls_back_on :name => 'fallback',
                :loss_factor => lambda { (EgridCountry.us.generation + EgridCountry.us.imports - EgridCountry.us.consumption) / EgridCountry.us.generation }
  
  col :name
  col :loss_factor, :type => :float
end
