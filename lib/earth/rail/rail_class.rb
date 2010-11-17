class RailClass < ActiveRecord::Base
  set_primary_key :name
  
  has_many :rail_trips
  
  data_miner do
    tap "Brighter Planet's rail class data", Earth.taps_server
  end
end
