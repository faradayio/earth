class MerchantCategory < ActiveRecord::Base
  set_primary_key :mcc

  has_many :merchant_category_industries, :foreign_key => 'mcc'
  has_many :industries, :through => :merchant_category_industries

  def name
    description
  end

  create_table do
    string 'mcc'
    string 'description'
  end

  data_miner do
    # Intentionally left blank.
  end
end
