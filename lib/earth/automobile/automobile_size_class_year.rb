class AutomobileSizeClassYear < ActiveRecord::Base
  set_primary_key :name

  col :name
  col :size_class_name
  col :year, :type => :integer
  col :type_name
  col :fuel_efficiency_city, :type => :float
  col :fuel_efficiency_city_units
  col :fuel_efficiency_highway, :type => :float
  col :fuel_efficiency_highway_units
end