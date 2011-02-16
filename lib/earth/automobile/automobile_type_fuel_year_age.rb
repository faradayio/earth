class AutomobileTypeFuelYearAge < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :automobile_type_fuel_year, :foreign_key => 'type_fuel_year_name', :primary_key => 'name'
  
  data_miner do
    tap "Brighter Planet's sanitized automobile type fuel age", Earth.taps_server
  end
end
