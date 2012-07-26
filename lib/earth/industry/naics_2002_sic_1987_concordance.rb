class Naics2002Sic1987Concordance < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "naics2002_sic1987_concordances"
  (
     "row_hash"        CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "naics_2002_code" CHARACTER VARYING(255),
     "sic_1987_code"   CHARACTER VARYING(255),
     "sic_note"        CHARACTER VARYING(255)
  );
EOS

  self.primary_key = "row_hash"
  
  belongs_to :naics_2002, :foreign_key => :naics_2002_code
  belongs_to :sic_1987,   :foreign_key => :sic_1987_code
  
  # for data import
  def self.extract_note(description)
    (note = description.match /.+?\((.+)\)/) ? note.captures.first : nil
  end
  
end
