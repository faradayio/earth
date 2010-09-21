class MerchantCategoryIndustry < ActiveRecord::Base
  extend Earth::Base
  set_primary_key :row_hash
  
  belongs_to :merchant_category, :foreign_key => 'mcc'
  belongs_to :industry,          :foreign_key => 'naics_code'

  def self.schema_definition
    lambda do
      string 'row_hash'
      string 'mcc'
      float  'ratio'
      string 'naics_code'
    end
  end

  data_miner do
    MerchantCategoryIndustry.define_schema(self)
  end
end
