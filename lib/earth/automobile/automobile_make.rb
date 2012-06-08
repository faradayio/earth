class AutomobileMake < ActiveRecord::Base
  self.primary_key = "name"
  
  # for calculating fuel efficiency
  has_many :make_years, :foreign_key => :make_name, :primary_key => :name, :class_name => 'AutomobileMakeYear'
  
  col :name
  col :fuel_efficiency, :type => :float
  col :fuel_efficiency_units
end
