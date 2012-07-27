require 'falls_back_on'

require 'earth/model'

class AirConditionerUse < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "air_conditioner_uses"
  (
     "name"                    CHARACTER VARYING(255) NOT NULL,
     "fugitive_emission"       FLOAT,
     "fugitive_emission_units" CHARACTER VARYING(255)
  );
ALTER TABLE "air_conditioner_uses" ADD PRIMARY KEY ("name")
EOS

  self.primary_key = "name"
  
  has_many :residential_energy_consumption_survey_responses

  falls_back_on :fugitive_emission => 0.102295.pounds_per_square_foot.to(:kilograms_per_square_metre), # https://brighterplanet.sifterapp.com/projects/30/issues/430
                :fugitive_emission_units => 'kilograms_per_square_metre'


  warn_unless_size 4
end
