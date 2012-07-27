require 'earth/model'

class Breed < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "breeds"
  (
     "name"         CHARACTER VARYING(255) NOT NULL,
     "species_name" CHARACTER VARYING(255),
     "weight"       FLOAT,
     "weight_units" CHARACTER VARYING(255)
  );
ALTER TABLE "breeds" ADD PRIMARY KEY ("name")
EOS

  self.primary_key = "name"
  
  has_many :breed_genders, :foreign_key => 'breed_name'
  belongs_to :species, :foreign_key => 'species_name'
  

  warn_if_nulls_except(
    :weight,
    :weight_units
  )

  warn_unless_size 522
end
