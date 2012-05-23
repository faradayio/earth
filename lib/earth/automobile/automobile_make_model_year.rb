require 'earth/fuel'
class AutomobileMakeModelYear < ActiveRecord::Base
  self.primary_key = "name"
  
  # Need this so Automobile and AutomobileTrip can do characteristics[:make_model_year].automobile_fuel
  belongs_to :automobile_fuel, :foreign_key => 'fuel_code', :primary_key => 'code'
  
  col :name
  col :make_name
  col :model_name
  col :year, :type => :integer
  col :hybridity,:type => :boolean
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
  col :weighting, :type => :float # for calculating AutomobileMakeModel fuel efficiencies
end
