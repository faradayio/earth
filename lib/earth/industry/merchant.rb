class Merchant < ActiveRecord::Base
  extend Earth::Base
  set_primary_key :id
  
  belongs_to :merchant_category, :foreign_key => 'mcc'

  def self.schema_definition
    lambda do
      string 'id'
      string 'name'
      string 'mcc'
    end
  end

  data_miner do
    Merchant.define_schema(self)
  end
end
