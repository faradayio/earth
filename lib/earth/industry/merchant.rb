class Merchant < ActiveRecord::Base
  self.primary_key = :id
  
  belongs_to :merchant_category, :foreign_key => 'mcc'

  col :id
  col :name
  col :mcc
end
