class Sic1987 < ActiveRecord::Base
  self.primary_key = "code"
  self.table_name = "sic_1987"
  
  has_many :naics_2002_sic_1987_concordances, :foreign_key => :sic_1987_code
  has_many :naics_2002, :through => :naics_2002_sic_1987_concordances
  has_many :industries, :through => :naics_2002
  
  # for data import
  def self.format_description(description)
    (desc = description.match /^(.+?) \(/) ? desc.captures.first : description
  end
  
  col :code
  col :description
end
