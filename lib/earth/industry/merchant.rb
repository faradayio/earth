class Merchant < ActiveRecord::Base
  set_primary_key :id
  
  belongs_to :merchant_category, :foreign_key => 'mcc'

  force_schema do
    string 'id'
    string 'name'
    string 'mcc'
  end
end
