require 'earth/model'
require 'earth/locality'
class IndustryProductLine < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "industry_product_lines"
  (
     "row_hash"   CHARACTER VARYING(255) NOT NULL,
     "naics_code" CHARACTER VARYING(255),
     "ratio"      FLOAT,
     "ps_code"    CHARACTER VARYING(255)
  );
ALTER TABLE "industry_product_lines" ADD PRIMARY KEY ("row_hash")
EOS

  self.primary_key = "row_hash"
  
  belongs_to :industry,     :foreign_key => 'naics_code'
  belongs_to :product_line, :foreign_key => 'ps_code'

end
