class AutomobileMakeYearFleet < ActiveRecord::Base
  self.primary_key = "name"
  
  col :name
  col :make_name
  col :year, :type => :integer
  col :fleet
  col :fuel_efficiency, :type => :float
  col :fuel_efficiency_units
  col :volume, :type => :integer
  
  warn_unless_size 1349
end
