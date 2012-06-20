class AutomobileMakeModel < ActiveRecord::Base
  self.primary_key = "name"
  
  # Used by Automobile and AutomobileTrip to look up auto fuel and alt auto fuel
  belongs_to :automobile_fuel, :foreign_key => :fuel_code, :primary_key => :code
  belongs_to :alt_automobile_fuel, :foreign_key => :alt_fuel_code, :primary_key => :code, :class_name => 'AutomobileFuel'
  
  # Used by Automobile and AutomobileTrip to look up a make model year considering fuel
  def self.custom_find(characteristics)
    if characteristics[:make] and characteristics[:model]
      # append fuel suffix to model name and search
      make_model = if characteristics[:automobile_fuel]
        find_by_make_name_and_model_name characteristics[:make].name, [characteristics[:model].name, characteristics[:automobile_fuel].suffix].join(' ')
      end
      
      # use original model name if fuel suffix didn't help
      make_model ? make_model : AutomobileMakeModel.find_by_make_name_and_model_name(characteristics[:make].name, characteristics[:model].name)
    end
  end
  
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
  
  warn_unless_size 2353
  warn_if_nulls_except :alt_fuel_code
  warn_if_nulls /alt_fuel_efficiency/, :conditions => 'alt_fuel_code IS NOT NULL'
end
