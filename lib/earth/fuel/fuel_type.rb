class FuelType < ActiveRecord::Base
  set_primary_key :name
  
  has_many :prices, :class_name => 'FuelPrice', :foreign_key => 'name' # weird
  
  falls_back_on :emission_factor               => 1.0, #FIXME TODO put a real value here - also do we want to do emission factors in kg / kj?
                :emission_factor_units         => 'FIXME',
                :average_purchase_volume       => 100, #FIXME TODO put a real value here - also do we want to do volumes in kJ?
                :average_purchase_volume_units => 'FIXME'
  
  data_miner do
    tap "Brighter Planet's fuel types data", TAPS_SERVER
  end
  
  def price
    prices.average :price
  end
end
