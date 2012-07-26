class RailTraction < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "rail_tractions"
  (
     "name" CHARACTER VARYING(255) NOT NULL
  );
ALTER TABLE "rail_tractions" ADD PRIMARY KEY ("name")
EOS

  self.primary_key = "name"
  

  warn_unless_size 2
end
