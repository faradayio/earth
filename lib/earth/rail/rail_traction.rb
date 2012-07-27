require 'earth/model'
class RailTraction < ActiveRecord::Base
  extend Earth::Model

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
