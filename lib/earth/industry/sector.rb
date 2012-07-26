class Sector < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "sectors"
  (
     "io_code"     CHARACTER VARYING(255) NOT NULL,
     "description" TEXT,
     "value"       FLOAT,
     "value_units" CHARACTER VARYING(255)
  );
ALTER TABLE "sectors" ADD PRIMARY KEY ("io_code")
EOS

  self.primary_key = "io_code"

  has_many :industry_sectors, :foreign_key => 'io_code'
  
end
