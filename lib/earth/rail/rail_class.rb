require 'earth/model'

class RailClass < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "rail_classes"
  (
     "name" CHARACTER VARYING(255) NOT NULL PRIMARY KEY
  );
EOS

  self.primary_key = "name"
  
  warn_unless_size 6
end
