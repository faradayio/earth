class AutomobileTypeFuelYearControl < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :control, :class_name => 'AutomobileTypeFuelControl', :foreign_key => 'type_fuel_control_name'
  
  data_miner do
    tap "Brighter Planet's sanitized automobile type fuel year control data", Earth.taps_server
  end
end
