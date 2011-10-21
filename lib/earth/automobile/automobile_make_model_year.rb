class AutomobileMakeModelYear < ActiveRecord::Base
  set_primary_key :name
  
  col :name # make + model + year
  col :make_name
  col :model_name
  col :year, :type => :integer
  col :fuel_efficiency_city, :type => :float
  col :fuel_efficiency_city_units
  col :fuel_efficiency_highway, :type => :float
  col :fuel_efficiency_highway_units
end
