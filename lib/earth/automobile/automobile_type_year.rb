class AutomobileTypeYear < ActiveRecord::Base
  set_primary_key :name
  
  has_many :type_fuel_years, :class_name => 'AutomobileTypeFuelYear', :foreign_key => 'type_year_name'
  
  data_miner do
    tap "Brighter Planet's sanitized automobile type year data", Earth.taps_server
  end
end
