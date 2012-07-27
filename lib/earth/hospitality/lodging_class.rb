require 'earth/model'

class LodgingClass < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "lodging_classes"
  (
     "name" CHARACTER VARYING(255) NOT NULL
  );
ALTER TABLE "lodging_classes" ADD PRIMARY KEY ("name")
EOS

  self.primary_key = "name"
  

  warn_unless_size 3
end
