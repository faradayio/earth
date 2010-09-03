class Sector < ActiveRecord::Base
  set_primary_key :io_code

  has_many :product_lines_sectors, :class_name => 'ProductLinesSectors', :foreign_key => 'io_code'

  class << self
    def key_map
      @key_map ||= sector_map.values.sort
    end

    def sector_map
      @sector_map ||= Sector.all.inject({}) do |map, sector|
        map[sector.description] = sector.io_code
        map
      end
    end
  end

  data_miner do
    schema Earth.database_options do
      string 'io_code'
      string 'description'
    end
  end
end
