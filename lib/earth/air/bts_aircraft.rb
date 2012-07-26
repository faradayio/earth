class BtsAircraft < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "bts_aircraft"
  (
     "bts_code"    CHARACTER VARYING(255) NOT NULL,
     "description" CHARACTER VARYING(255)
  );
ALTER TABLE "bts_aircraft" ADD PRIMARY KEY ("bts_code")
EOS

  self.primary_key = "bts_code"

  warn_unless_size 379
end
