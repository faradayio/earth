class LodgingClass < ActiveRecord::Base
  set_primary_key :name
  
  has_many :lodgings
  
  data_miner do
    tap "Brighter Planet's lodging class data", Earth.taps_server
  end
  
  # based on science/emitters/lodging/lodging_classes.xls
  falls_back_on :emission_factor => 20.976.pounds.to(:kilograms)
end
