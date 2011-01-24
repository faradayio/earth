class ResidentialEnergyConsumptionSurveyResponse < ActiveRecord::Base
  set_primary_key :id
  set_table_name :recs_responses
  
  belongs_to :census_division,     :foreign_key => 'census_division_number'
  belongs_to :census_region,       :foreign_key => 'census_region_number'
  # what follows are entirely derived here
  belongs_to :residence_class
  belongs_to :urbanity
  belongs_to :dishwasher_use
  belongs_to :air_conditioner_use
  belongs_to :clothes_machine_use
  
  extend CohortScope
  self.minimum_cohort_size = 5
  SUBCOHORT_THRESHOLD = 5 # per Matt
  
  INPUT_CHARACTERISTICS = [
    :census_region,
    :heating_degree_days,
    :cooling_degree_days,
    :residence_class,
    :rooms,
    :bedrooms,
    :bathrooms,
    :floorspace,
    :residents,
    :urbanity,
    :construction_year,
    :ownership,
  ]
  
  data_miner do
    tap "Brighter Planet's sanitized RECS 2005", Earth.taps_server
    
    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
end
