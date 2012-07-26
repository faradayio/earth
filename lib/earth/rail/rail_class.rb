class RailClass < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "rail_classes"
  (
     "name" CHARACTER VARYING(255) NOT NULL
  );
ALTER TABLE "rail_classes" ADD PRIMARY KEY ("name")
EOS

  self.primary_key = "name"
  

  warn_unless_size 6
end
