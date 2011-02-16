class AutomobileTypeFuelYear < ActiveRecord::Base
  set_primary_key :name
  
  has_many :year_controls, :class_name => 'AutomobileTypeFuelYearControl', :foreign_key => 'type_fuel_year_name'
  
  data_miner do
    tap "Brighter Planet's sanitized automobile type fuel year data", Earth.taps_server
  end
end
