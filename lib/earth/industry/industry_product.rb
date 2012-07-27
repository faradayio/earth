require 'earth/model'
require 'earth/locality'
class IndustryProduct < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "industry_products"
  (
     "naics_product_code" CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "description"        TEXT,
     "value"              FLOAT,
     "value_units"        CHARACTER VARYING(255),
     "naics_code"         CHARACTER VARYING(255)
  );
EOS

  self.primary_key = "naics_product_code"
  
  has_many :product_line_industry_products, :foreign_key => 'naics_product_code'
  
  belongs_to :industry, :foreign_key => 'naics_code'
  
end
