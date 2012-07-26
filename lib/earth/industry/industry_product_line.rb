require 'earth/locality'
class IndustryProductLine < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "industry_product_lines"
  (
     "row_hash"   CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "naics_code" CHARACTER VARYING(255),
     "ratio"      FLOAT,
     "ps_code"    CHARACTER VARYING(255)
  );
EOS

  self.primary_key = "row_hash"
  
  belongs_to :industry,     :foreign_key => 'naics_code'
  belongs_to :product_line, :foreign_key => 'ps_code'

end
