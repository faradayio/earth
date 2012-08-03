require 'earth/hospitality/commercial_building_energy_consumption_survey_response'

FactoryGirl.define do
  factory :cbecs_response, :class => CommercialBuildingEnergyConsumptionSurveyResponse do
    trait(:hotel) { id 9991; detailed_activity 'Hotel' }
    trait(:motel) { id 9992; detailed_activity 'Motel or inn' }
    trait(:warehouse) { id 9993; detailed_activity 'Warehouse/storage' }
    trait(:hotel_warehouse) { id 9994; detailed_activity 'Hotel'; first_activity 'Warehouse/storage' }
  end
end
