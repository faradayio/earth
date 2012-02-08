class NationalTransitDatabaseMode < ActiveRecord::Base
  self.primary_key = :code
  self.table_name = :ntd_modes
  
  def self.rail_modes
    where(:rail_mode => true)
  end
  
  col :code
  col :name
  col :rail_mode, :type => :boolean
end
