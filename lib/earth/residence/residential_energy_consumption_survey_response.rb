class ResidentialEnergyConsumptionSurveyResponse < ActiveRecord::Base
  set_primary_key :department_of_energy_identifier
    
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
        
    process "rename certain columns so that we can use them as association names" do
      connection.rename_column :residential_energy_consumption_survey_responses, :dishwasher_use, :dishwasher_use_id
    end
    
    process "synthesize air conditioner use from central AC and window AC use" do
      connection.add_column :residential_energy_consumption_survey_responses, :air_conditioner_use_id, :string
      update_all "air_conditioner_use_id = 'Turned on just about all summer'",                        " central_ac_use = 'Turned on just about all summer'                        OR window_ac_use = 'Turned on just about all summer'"
      update_all "air_conditioner_use_id = 'Turned on quite a bit'",                                  "(central_ac_use = 'Turned on quite a bit'                                  OR window_ac_use = 'Turned on quite a bit')                                  AND air_conditioner_use_id IS NULL"
      update_all "air_conditioner_use_id = 'Turned on only a few days or nights when really needed'", "(central_ac_use = 'Turned on only a few days or nights when really needed' OR window_ac_use = 'Turned on only a few days or nights when really needed') AND air_conditioner_use_id IS NULL"
      update_all "air_conditioner_use_id = 'Not used at all'",                                        "(central_ac_use = 'Not used at all'                                        OR window_ac_use = 'Not used at all')                                        AND air_conditioner_use_id IS NULL"
    end
    
    process "synthesize clothes machine use from washer and dryer use" do
      connection.add_column :residential_energy_consumption_survey_responses, :clothes_machine_use_id, :string
      update_all "clothes_machine_use_id = clothes_washer_use",         "                                                    clothes_dryer_use = 'Use it every time you wash clothes'"
      update_all "clothes_machine_use_id = NULL",                       "clothes_washer_use IS NULL                      AND clothes_dryer_use = 'Use it for some, but not all, loads of wash'"
      update_all "clothes_machine_use_id = '1 load or less each week'", "clothes_washer_use = '1 load or less each week' AND clothes_dryer_use = 'Use it for some, but not all, loads of wash'"
      update_all "clothes_machine_use_id = '1 load or less each week'", "clothes_washer_use = '2 to 4 loads'             AND clothes_dryer_use = 'Use it for some, but not all, loads of wash'"
      update_all "clothes_machine_use_id = '2 to 4 loads'",             "clothes_washer_use = '5 to 9 loads'             AND clothes_dryer_use = 'Use it for some, but not all, loads of wash'"
      update_all "clothes_machine_use_id = '5 to 9 loads'",             "clothes_washer_use = '10 to 15 loads'           AND clothes_dryer_use = 'Use it for some, but not all, loads of wash'"
      update_all "clothes_machine_use_id = '10 to 15 loads'",           "clothes_washer_use = 'More than 15 loads'       AND clothes_dryer_use = 'Use it for some, but not all, loads of wash'"
      update_all "clothes_machine_use_id = NULL",                       "clothes_washer_use IS NULL                      AND clothes_dryer_use = 'Use it infrequently'"
      update_all "clothes_machine_use_id = '1 load or less each week'", "clothes_washer_use = '1 load or less each week' AND clothes_dryer_use = 'Use it infrequently'"
      update_all "clothes_machine_use_id = '1 load or less each week'", "clothes_washer_use = '5 to 9 loads'             AND clothes_dryer_use = 'Use it infrequently'"
      update_all "clothes_machine_use_id = '2 to 4 loads'",             "clothes_washer_use = '10 to 15 loads'           AND clothes_dryer_use = 'Use it infrequently'"
      update_all "clothes_machine_use_id = '5 to 9 loads'",             "clothes_washer_use = 'More than 15 loads'       AND clothes_dryer_use = 'Use it infrequently'"
    end

    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
end
