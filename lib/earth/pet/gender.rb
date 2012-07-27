require 'earth/model'

class Gender < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "genders"
  (
     "name" CHARACTER VARYING(255) NOT NULL
  );
ALTER TABLE "genders" ADD PRIMARY KEY ("name")
EOS

  self.primary_key = "name"
  
  has_many :breed_genders, :foreign_key => 'gender_name'
  

  warn_unless_size 2
end
