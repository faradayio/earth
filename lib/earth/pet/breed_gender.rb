class BreedGender < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "breed_genders"
  (
     "name"         CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "breed_name"   CHARACTER VARYING(255),
     "gender_name"  CHARACTER VARYING(255),
     "weight"       FLOAT,
     "weight_units" CHARACTER VARYING(255)
  );
EOS

  self.primary_key = "name"
  
  belongs_to :breed, :foreign_key => 'breed_name'
  belongs_to :gender, :foreign_key => 'gender_name'
  

  warn_unless_size 586
end
