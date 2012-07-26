require 'earth/locality'
class IndustrySector < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "industry_sectors"
  (
     "row_hash"   CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "naics_code" CHARACTER VARYING(255),
     "ratio"      FLOAT,
     "io_code"    CHARACTER VARYING(255)
  );
EOS

  self.primary_key = "row_hash"
  
  belongs_to :industry,  :foreign_key => 'naics_code'
  belongs_to :sector,    :foreign_key => 'io_code'

end
