class LodgingClass < ActiveRecord::Base
  set_primary_key :name
  
  has_many :lodgings
  
  data_miner do
    tap "Brighter Planet's lodging class data", Earth.taps_server
  end
end
