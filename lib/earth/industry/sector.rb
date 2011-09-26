class Sector < ActiveRecord::Base
  set_primary_key :io_code

  has_many :industry_sectors, :foreign_key => 'io_code'
  
  col :io_code
  col :description, :type => :text
  col :value, :type => :float
  col :value_units
end