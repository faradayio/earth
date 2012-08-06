require 'earth/model'

require 'earth/residence/residential_energy_consumption_survey_response'

class Urbanity < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "urbanities"
  (
     "name" CHARACTER VARYING(255) NOT NULL PRIMARY KEY
  );
EOS

  self.primary_key = "name"
  
  has_many :residential_energy_consumption_survey_responses

  warn_unless_size 4
end
