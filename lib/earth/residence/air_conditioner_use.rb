class AirConditionerUse < ActiveRecord::Base
  set_primary_key :name
  
  has_many :residences
  has_many :residential_energy_consumption_survey_responses

  falls_back_on :fugitive_emission => 0.102295.pounds_per_square_foot.to(:kilograms_per_square_metre), # https://brighterplanet.sifterapp.com/projects/30/issues/430
                :fugitive_emission_units => 'kilograms_per_square_metre'
  
  data_miner do
    schema do
      string 'name'
      float 'fugitive_emission'
      string 'fugitive_emission_units'
    end

    process "derive from ResidentialEnergyConsumptionSurveyResponse" do
      ResidentialEnergyConsumptionSurveyResponse.run_data_miner!
      connection.execute %{
        INSERT IGNORE INTO air_conditioner_uses(name)
        SELECT DISTINCT residential_energy_consumption_survey_responses.central_ac_use FROM residential_energy_consumption_survey_responses WHERE LENGTH(residential_energy_consumption_survey_responses.central_ac_use) > 0
      }
    end
    
    import "Ian's precalculated fugitive emissions values", :url => 'http://spreadsheets.google.com/pub?key=ri_380yQZAqBKeqie_TECgg' do
      key 'name', :field_name => 'air_conditioner_use_name'
      store 'fugitive_emission', :units_field_name => 'unit', :to_units => :kilograms_per_square_metre
    end
  end
end
