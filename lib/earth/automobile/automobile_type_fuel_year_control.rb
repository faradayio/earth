class AutomobileTypeFuelYearControl < ActiveRecord::Base
  self.primary_key = "name"
  
  # Needs to be a belongs_to so that it gets imported with taps for AutomobileTypeFuelYear ch4 and n2o ef calculation
  belongs_to :type_fuel_control, :foreign_key => :type_fuel_control_name, :class_name => 'AutomobileTypeFuelControl'
  
  # Used by AutomobileTypeFuelYear
  def self.find_all_by_type_name_and_fuel_family_and_closest_year(type_name, fuel_family, year)
    if year > maximum(:year)
      where(:type_name => type_name, :fuel_family => fuel_family, :year => maximum(:year))
    else
      where(:type_name => type_name, :fuel_family => fuel_family, :year => [year, minimum(:year)].max)
    end
  end
  
  %w{ ch4_emission_factor n2o_emission_factor }.each do |method|
    define_method method do
      type_fuel_control.send(method)
    end
    
    units_method = method + '_units'
    define_method units_method do
      type_fuel_control.send(units_method)
    end
  end
  
  col :name
  col :type_name
  col :fuel_family
  col :year, :type => :integer
  col :control_name
  col :type_fuel_control_name
  col :total_travel_percent, :type => :float
  
  warn_unless_size 142
end
