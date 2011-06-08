class Merchant < ActiveRecord::Base
  set_primary_key :id
  
  belongs_to :merchant_category, :foreign_key => 'mcc'

  create_table do
    string 'id'
    string 'name'
    string 'mcc'
  end
end
