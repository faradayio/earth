class NationalTransitDatabaseMode < ActiveRecord::Base
  set_primary_key :code
  set_table_name :ntd_modes
  
  def self.rail_modes
    self.where(:rail_mode => true)
  end
  
  col :code
  col :name
  col :rail_mode, :type => :boolean
end
