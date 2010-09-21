class ProductLine < ActiveRecord::Base
  extend Earth::Base
  set_primary_key :ps_code
  
  has_many :product_line_sectors, :foreign_key => 'ps_code'
  has_many :sectors, :through => :product_line_sectors
  
  def self.schema_definition
    lambda do
      string 'ps_code'
      string 'description'
      string 'broadline' # FIXME TODO do we need this?
      string 'parent'    # FIXME TODO do we need this?
    end
  end

  data_miner do
    ProductLine.define_schema(self)
  end
end
