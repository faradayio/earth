class AutomobileTypeFuelYearAge < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :type_fuel_year, :class_name => 'AutomobileTypeFuelYear', :foreign_key => 'type_fuel_year_name'
  
  data_miner do
    tap "Brighter Planet's sanitized automobile type fuel age", Earth.taps_server
  end
end
