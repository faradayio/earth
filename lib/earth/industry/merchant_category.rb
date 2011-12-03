class MerchantCategory < ActiveRecord::Base
  set_primary_key :mcc

  has_many :merchant_category_industries, :foreign_key => 'mcc'
  has_many :industries, :through => :merchant_category_industries

  def name
    description
  end

  col :mcc
  col :description
end