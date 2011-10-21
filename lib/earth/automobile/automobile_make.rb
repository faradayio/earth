class AutomobileMake < ActiveRecord::Base
  set_primary_key :name
  
  col :name
  col :fuel_efficiency, :type => :float
  col :fuel_efficiency_units
end
