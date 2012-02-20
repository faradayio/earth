class Naics2007 < ActiveRecord::Base
  self.primary_key = "code"
  self.table_name = "naics_2007"
  
  has_many :naics_2002_naics_2007_concordances, :foreign_key => :naics_2007_code
  has_many :naics_2002, :through => :naics_2002_naics_2007_concordances
  
  col :code
  col :description
end
