require 'earth/locality'
class IndustrySector < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "industry_sectors"
  (
     "row_hash"   CHARACTER VARYING(255) NOT NULL,
     "naics_code" CHARACTER VARYING(255),
     "ratio"      FLOAT,
     "io_code"    CHARACTER VARYING(255)
  );
ALTER TABLE "industry_sectors" ADD PRIMARY KEY ("row_hash")
EOS

  self.primary_key = "row_hash"
  
  belongs_to :industry,  :foreign_key => 'naics_code'
  belongs_to :sector,    :foreign_key => 'io_code'

end
