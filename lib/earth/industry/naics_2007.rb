require 'earth/model'

require 'earth/industry/naics_2002_naics_2007_concordance'
require 'earth/industry/naics_2002'

class Naics2007 < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "naics_2007"
  (
     "code"        CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "description" CHARACTER VARYING(255)
  );
EOS

  self.primary_key = "code"
  self.table_name = "naics_2007"
  
  has_many :naics_2002_naics_2007_concordances, :foreign_key => :naics_2007_code
  has_many :naics_2002, :through => :naics_2002_naics_2007_concordances
  
  warn_unless_size 2328
end
