class MerchantCategory < ActiveRecord::Base
  set_primary_key :mcc

  has_many :merchant_categories_industries, :foreign_key => 'mcc', :class_name => 'MerchantCategoriesIndustries'
  has_many :industries, :through => :merchant_categories_industries

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
