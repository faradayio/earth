class Naics2002Naics2007Concordance < ActiveRecord::Base
  self.primary_key = "row_hash"
  
  belongs_to :naics_2002, :foreign_key => :naics_2002_code
  belongs_to :naics_2007, :foreign_key => :naics_2007_code
  
  # for data import
  def self.extract_note(description)
    (note = description.match(/ - (.+)/)) ? note.captures.first : nil
  end
  
  col :row_hash
  col :naics_2002_code
  col :naics_2007_code
  col :naics_2002_note
end
