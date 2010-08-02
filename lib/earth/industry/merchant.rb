class Merchant < ActiveRecord::Base
  set_primary_key :id
  
  belongs_to :merchant_category, :foreign_key => 'mcc'

  data_miner do
    schema Earth.database_options do
      string 'id'
      string 'name'
      string 'mcc'
    end
  end
end
