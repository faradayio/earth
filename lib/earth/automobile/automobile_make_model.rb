class AutomobileMakeModel < ActiveRecord::Base
  self.primary_key = "name"
  
  # Used by Automobile and AutomobileTrip to look up auto fuel and alt auto fuel
  belongs_to :automobile_fuel, :foreign_key => :fuel_code, :primary_key => :code
  belongs_to :alt_automobile_fuel, :foreign_key => :alt_fuel_code, :primary_key => :code, :class_name => 'AutomobileFuel'
  
  # for deriving fuel codes and type name
  def model_years
    AutomobileMakeModelYear.where(:make_name => make_name, :model_name => model_name)
  end
  
  col :name
  col :make_name
  col :model_name
  col :fuel_code
  col :fuel_efficiency_city, :type => :float
  col :fuel_efficiency_city_units
  col :fuel_efficiency_highway, :type => :float
  col :fuel_efficiency_highway_units
  col :alt_fuel_code
  col :alt_fuel_efficiency_city, :type => :float
  col :alt_fuel_efficiency_city_units
  col :alt_fuel_efficiency_highway, :type => :float
  col :alt_fuel_efficiency_highway_units
  col :type_name
end
