class AutomobileFuelType < ActiveRecord::Base
  set_primary_key :code
  
  has_many :automobiles, :foreign_key => 'fuel_type_id'
  
  scope :ordered, :order => 'name'
  
  falls_back_on :emission_factor => 20.781.pounds_per_gallon.to(:kilograms_per_litre) # https://brighterplanet.sifterapp.com/projects/30/issues/428
  
  data_miner do
    tap "Brighter Planet's sanitized automobile fuel type data", TAPS_SERVER
  end
  
  CODES = {
    :electricity => 'El',
    :diesel => 'D'
  }
end
