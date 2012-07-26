class ClothesMachineUse < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "clothes_machine_uses"
  (
     "name"                                                    CHARACTER VARYING
     (255) NOT NULL,
     "annual_energy_from_electricity_for_clothes_driers"       FLOAT,
     "annual_energy_from_electricity_for_clothes_driers_units" CHARACTER VARYING
     (255)
  );
ALTER TABLE "clothes_machine_uses" ADD PRIMARY KEY ("name")
EOS

  self.primary_key = "name"
  
  has_many :residential_energy_consumption_survey_responses


  warn_unless_size 5
end
