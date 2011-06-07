class DishwasherUse < ActiveRecord::Base
  set_primary_key :name
  
  has_many :residential_energy_consumption_survey_responses

  create_table do
    string 'name'
    float 'annual_energy_from_electricity_for_dishwashers'
    string 'annual_energy_from_electricity_for_dishwashers_units'
  end
end
