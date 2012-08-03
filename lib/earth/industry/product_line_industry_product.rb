require 'earth/model'

require 'earth/industry/product_line'
require 'earth/industry/industry_product'

class ProductLineIndustryProduct < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS

CREATE TABLE product_line_industry_products
  (
     row_hash           CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     ps_code            CHARACTER VARYING(255),
     ratio              FLOAT,
     naics_product_code CHARACTER VARYING(255)
  );

EOS

  self.primary_key = "row_hash"
  
  belongs_to :product_line,     :foreign_key => 'ps_code'
  belongs_to :industry_product, :foreign_key => 'naics_product_code'
end
