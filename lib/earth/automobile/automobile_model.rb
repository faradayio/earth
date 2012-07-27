require 'earth/model'

class AutomobileModel < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "automobile_models"
  (
     "name" CHARACTER VARYING(255) NOT NULL PRIMARY KEY
  );
EOS

  self.primary_key = "name"
  

  warn_unless_size 2299
end
