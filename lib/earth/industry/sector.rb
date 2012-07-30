require 'earth/model'

require 'earth/industry/industry_sector'

class Sector < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "sectors"
  (
     "io_code"     CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "description" TEXT,
     "value"       FLOAT,
     "value_units" CHARACTER VARYING(255)
  );
EOS

  self.primary_key = "io_code"

  has_many :industry_sectors, :foreign_key => 'io_code'
end
