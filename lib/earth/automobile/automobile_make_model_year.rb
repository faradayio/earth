require 'earth/fuel'
class AutomobileMakeModelYear < ActiveRecord::Base
  set_primary_key :name
  
  # Need this so Automobile and AutomobileTrip can do characteristics[:make_model_year].automobile_fuel
  belongs_to :automobile_fuel, :foreign_key => 'fuel_code', :primary_key => 'code'
  
  col :name # make + model + year
  col :make_name
  col :model_name
  col :year,                    :type => :integer
  col :fuel_code
  col :hybridity,               :type => :boolean
  col :fuel_efficiency_city,    :type => :float
  col :fuel_efficiency_city_units
  col :fuel_efficiency_highway, :type => :float
  col :fuel_efficiency_highway_units
end
