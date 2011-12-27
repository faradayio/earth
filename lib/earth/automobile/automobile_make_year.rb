require 'earth/fuel'
class AutomobileMakeYear < ActiveRecord::Base
  set_primary_key :name
  
  col :name
  col :make_name
  col :year, :type => :integer
  col :fuel_efficiency, :type => :float
  col :fuel_efficiency_units
  col :volume, :type => :integer # This will sometimes be null because not all make_years have CAFE data
end
