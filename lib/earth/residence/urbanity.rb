require 'earth/model'

class Urbanity < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "urbanities"
  (
     "name" CHARACTER VARYING(255) NOT NULL
  );
ALTER TABLE "urbanities" ADD PRIMARY KEY ("name")
EOS

  self.primary_key = "name"
  
  has_many :residential_energy_consumption_survey_responses


  warn_unless_size 4
end
