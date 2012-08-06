require 'earth/model'

require 'earth/industry/industry'
require 'earth/industry/naics_2002_naics_2007_concordance'
require 'earth/industry/naics_2002_sic_1987_concordance'
require 'earth/industry/naics_2007'
require 'earth/industry/sic_1987'

class Naics2002 < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS

CREATE TABLE naics_2002
  (
     code        CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     description CHARACTER VARYING(255)
  );

EOS

  self.primary_key = "code"
  self.table_name = "naics_2002"
  
  belongs_to :industry, :foreign_key => :code
  
  has_many :naics_2002_sic_1987_concordances, :foreign_key => :naics_2002_code
  has_many :sic_1987, :through => :naics_2002_sic_1987_concordances
  
  has_many :naics_2002_naics_2007_concordances, :foreign_key => :naics_2002_code
  has_many :naics_2007, :through => :naics_2002_naics_2007_concordances
  
  warn_unless_size 2341
end
