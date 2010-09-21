class MerchantCategory < ActiveRecord::Base
  extend Earth::Base
  set_primary_key :mcc

  has_many :merchant_category_industries, :foreign_key => 'mcc'
  has_many :industries, :through => :merchant_category_industries

  def name
    description
  end

  data_miner do
    schema Earth.database_options do
      string 'mcc'
      string 'description'
    end
  end
end
