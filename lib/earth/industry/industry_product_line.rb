class IndustryProductLine < ActiveRecord::Base
  set_primary_key :row_hash
  
  belongs_to :industry,     :foreign_key => 'naics_code'
  belongs_to :product_line, :foreign_key => 'ps_code'

  force_schema do
    string 'row_hash'
    string 'naics_code'
    float  'ratio'
    string 'ps_code'
  end
end
