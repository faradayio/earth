class Sector < ActiveRecord::Base
  set_primary_key :io_code

  has_many :industry_sectors, :foreign_key => 'io_code'
  
  force_schema do
    string 'io_code'
    string 'description'
    float  'value'
    string 'value_units'
  end
end
