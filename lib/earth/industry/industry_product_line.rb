require 'earth/locality'
class IndustryProductLine < ActiveRecord::Base
  self.primary_key = :row_hash
  
  belongs_to :industry,     :foreign_key => 'naics_code'
  belongs_to :product_line, :foreign_key => 'ps_code'

  col :row_hash
  col :naics_code
  col :ratio, :type => :float
  col :ps_code
end
