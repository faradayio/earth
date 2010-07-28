class MerchantCategory < ActiveRecord::Base
  set_primary_key :mcc

  has_many :industries, :through => :merchant_categories_industries

  data_miner do
    tap "Brighter Planet's merchant category data", Earth.taps_server
  end
end
