class AutomobileMakeYear < ActiveRecord::Base
  self.primary_key = "name"
  
  col :name
  col :make_name
  col :year, :type => :integer
  col :fuel_efficiency, :type => :float
  col :fuel_efficiency_units
  col :weighting, :type => :float # for calculating AutomobileMake fuel efficiences
  
  warn_unless_size 1276
  warn_if_any_nulls
end
