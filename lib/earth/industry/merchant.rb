class Merchant < ActiveRecord::Base
  set_primary_key :id
  
  belongs_to :merchant_category, :foreign_key => 'mcc'
  
  data_miner do
    tap "Brighter Planet's merchant data", TAPS_SERVER
  end
end
