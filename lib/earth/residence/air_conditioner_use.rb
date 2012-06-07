class AirConditionerUse < ActiveRecord::Base
  self.primary_key = "name"
  
  has_many :residential_energy_consumption_survey_responses

  falls_back_on :fugitive_emission => 0.102295.pounds_per_square_foot.to(:kilograms_per_square_metre), # https://brighterplanet.sifterapp.com/projects/30/issues/430
                :fugitive_emission_units => 'kilograms_per_square_metre'

  col :name
  col :fugitive_emission, :type => :float
  col :fugitive_emission_units

  warn_unless_size 4
end
