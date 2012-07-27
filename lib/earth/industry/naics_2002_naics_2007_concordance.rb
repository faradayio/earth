require 'earth/model'

class Naics2002Naics2007Concordance < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "naics2002_naics2007_concordances"
  (
     "row_hash"        CHARACTER VARYING(255) NOT NULL,
     "naics_2002_code" CHARACTER VARYING(255),
     "naics_2007_code" CHARACTER VARYING(255),
     "naics_2002_note" CHARACTER VARYING(255)
  );
ALTER TABLE "naics2002_naics2007_concordances" ADD PRIMARY KEY ("row_hash")
EOS

  self.primary_key = "row_hash"
  
  belongs_to :naics_2002, :foreign_key => :naics_2002_code
  belongs_to :naics_2007, :foreign_key => :naics_2007_code
  
  # for data import
  def self.extract_note(description)
    (note = description.match(/ - (.+)/)) ? note.captures.first : nil
  end
  
end
