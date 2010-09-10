class LodgingClass < ActiveRecord::Base
  set_primary_key :name
  
  has_many :lodgings
  
  data_miner do
    tap "Brighter Planet's lodging class data", Earth.taps_server
  end
  
  # FIXME TODO need reall emission_factor
  falls_back_on :emission_factor => 1.0
end
