class NationalTransitDatabaseMode < ActiveRecord::Base
  set_primary_key :code
  set_table_name :ntd_modes
  
  def self.rail_classes
    self.where(:rail_class => true)
  end
  
  col :code
  col :name
  col :rail_class, :type => :boolean
end
