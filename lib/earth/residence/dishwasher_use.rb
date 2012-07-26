class DishwasherUse < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "dishwasher_uses"
  (
     "name"                                                 CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "annual_energy_from_electricity_for_dishwashers"       FLOAT,
     "annual_energy_from_electricity_for_dishwashers_units" CHARACTER VARYING(255)
  );
EOS

  self.primary_key = "name"
  
  has_many :residential_energy_consumption_survey_responses


  warn_unless_size 5
end
