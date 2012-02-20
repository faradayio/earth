class Naics2002 < ActiveRecord::Base
  self.primary_key = "code"
  self.table_name = "naics_2002"
  
  has_many :naics_2002_sic_1987_concordances, :foreign_key => :naics_2002_code
  has_many :sic_1987, :through => :naics_2002_sic_1987_concordances
  
  has_many :naics_2002_naics_2007_concordances, :foreign_key => :naics_2002_code
  has_many :naics_2007, :through => :naics_2002_naics_2007_concordances
  
  col :code
  col :description
end
