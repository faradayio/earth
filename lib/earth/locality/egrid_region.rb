class EgridRegion < ActiveRecord::Base
  set_primary_key :name
  
  has_many :egrid_subregions, :foreign_key => 'egrid_region_name'
  
  # FIXME TODO someday should calculate this from eGRID data: (USTNGN05 + USTNFI05 - USTCON05) / USTNGN05
  falls_back_on :name => 'fallback',
                :loss_factor => 0.061879 # calculated using above formula 2/21/2011
  
  col :name
  col :loss_factor, :type => :float
  
  # verify "Loss factor should be greater than zero and less than one" do
  #   EgridRegion.all.each do |region|
  #     unless region.loss_factor > 0 and region.loss_factor < 1
  #       raise "Invalid loss factor for EgridRegion #{region.name}: #{region.loss_factor} (should be > 0 and < 1)"
  #     end
  #   end
  # end
  
  # FIXME TODO verify fallback loss factor
  
end