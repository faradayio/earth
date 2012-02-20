class Naics2002Sic1987Concordance < ActiveRecord::Base
  self.primary_key = "row_hash"
  
  belongs_to :naics_2002, :foreign_key => :naics_2002_code
  belongs_to :sic_1987,   :foreign_key => :sic_1987_code
  
  # for data import
  def self.extract_note(description)
    (note = description.match /.+?\((.+)\)/) ? note.captures.first : nil
  end
  
  col :row_hash
  col :naics_2002_code
  col :sic_1987_code
  col :sic_note
end
