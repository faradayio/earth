require 'earth/model'

require 'earth/residence/residential_energy_consumption_survey_response'

class ClothesMachineUse < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "clothes_machine_uses"
  (
     "name"                                                    CHARACTER VARYING (255) NOT NULL PRIMARY KEY,
     "annual_energy_from_electricity_for_clothes_driers"       FLOAT,
     "annual_energy_from_electricity_for_clothes_driers_units" CHARACTER VARYING (255)
  );
EOS

  self.primary_key = "name"
  
  has_many :residential_energy_consumption_survey_responses


  warn_unless_size 5
end
