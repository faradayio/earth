require 'earth/locality'
class IndustrySector < ActiveRecord::Base
  set_primary_key :row_hash
  
  belongs_to :industry,  :foreign_key => 'naics_code'
  belongs_to :sector,    :foreign_key => 'io_code'

  col :row_hash
  col :naics_code
  col :ratio, :type => :float
  col :io_code
end