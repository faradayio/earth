class AutomobileMakeFleetYear < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :make,      :class_name => 'AutomobileMake',     :foreign_key => 'make_name'
  belongs_to :make_year, :class_name => 'AutomobileMakeYear', :foreign_key => 'make_year_name'

  col :name
  col :make_year_name
  col :make_name
  col :fleet
  col :year, :type => :integer
  col :fuel_efficiency, :type => :float
  col :fuel_efficiency_units
  col :volume, :type => :integer
end