class Sector < ActiveRecord::Base
  set_primary_key :io_code

  has_many :product_lines_sectors, :class_name => 'ProductLinesSectors', :foreign_key => 'io_code'

  data_miner do
    schema Earth.database_options do
      string 'io_code'
      string 'description'
    end
  end
end
