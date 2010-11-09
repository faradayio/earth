class AirConditionerUse < ActiveRecord::Base
  set_primary_key :name
  
  has_many :residences
  has_many :residential_energy_consumption_survey_responses

  falls_back_on :fugitive_emission => 0.102295.pounds_per_square_foot.to(:kilograms_per_square_metre), # https://brighterplanet.sifterapp.com/projects/30/issues/430
                :fugitive_emission_units => 'kilograms_per_square_metre'
  
  data_miner do
    tap "Brighter Planet's air conditioner use data", Earth.taps_server
  end
end
