class ProductLineIndustryProduct < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "product_line_industry_products"
  (
     "row_hash"           CHARACTER VARYING(255) NOT NULL,
     "ps_code"            CHARACTER VARYING(255),
     "ratio"              FLOAT,
     "naics_product_code" CHARACTER VARYING(255)
  );
ALTER TABLE "product_line_industry_products" ADD PRIMARY KEY ("row_hash")
EOS

  self.primary_key = "row_hash"
  
  belongs_to :product_line,     :foreign_key => 'ps_code'
  belongs_to :industry_product, :foreign_key => 'naics_product_code'

end
