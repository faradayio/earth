class DishwasherUse < ActiveRecord::Base
  set_primary_key :name
  
  has_many :residential_energy_consumption_survey_responses

  col :name
  col :annual_energy_from_electricity_for_dishwashers, :type => :float
  col :annual_energy_from_electricity_for_dishwashers_units
end