require 'earth/fuel'
class AutomobileMake < ActiveRecord::Base
  self.primary_key = "name"
  
  def make_years
    AutomobileMakeYear.where(:make_name => name)
  end
  
  def fuel_efficiency
    make_years.weighted_average(:fuel_efficiency)
  end
  
  def fuel_efficiency_units
    make_years.first.fuel_efficiency_units
  end
  
  col :name
end
