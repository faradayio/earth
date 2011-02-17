# DEPRECATED - use AutomobileFuel
class AutomobileFuelType < ActiveRecord::Base
  set_primary_key :code
  
  scope :ordered, :order => 'name'
  
  falls_back_on :emission_factor => 20.781.pounds_per_gallon.to(:kilograms_per_litre) # https://brighterplanet.sifterapp.com/projects/30/issues/428
  
  data_miner do
    tap "Brighter Planet's sanitized automobile fuel type data", Earth.taps_server
  end
  
  CODES = {
    :electricity => 'El',
    :diesel => 'D'
  }
end
