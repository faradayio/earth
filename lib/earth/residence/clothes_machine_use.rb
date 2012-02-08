class ClothesMachineUse < ActiveRecord::Base
  self.primary_key = :name
  
  has_many :residential_energy_consumption_survey_responses

  col :name
  col :annual_energy_from_electricity_for_clothes_driers, :type => :float
  col :annual_energy_from_electricity_for_clothes_driers_units
end
