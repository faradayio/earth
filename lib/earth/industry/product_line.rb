require 'earth/model'

require 'earth/industry/industry_product'
require 'earth/industry/industry_product_line'
require 'earth/industry/product_line_industry_product'

class ProductLine < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS

CREATE TABLE product_lines
  (
     ps_code     CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     description TEXT,
     broadline   CHARACTER VARYING(255), /* FIXME TODO do we need this? */
     parent      CHARACTER VARYING(255)  /* FIXME TODO do we need this? */
  );

EOS

  self.primary_key = "ps_code"
  
  has_many :industry_product_lines,         :foreign_key => 'ps_code'
  
  has_many :product_line_industry_products, :foreign_key => 'ps_code'
  has_many :industry_products, :through => :product_line_industry_products
end
