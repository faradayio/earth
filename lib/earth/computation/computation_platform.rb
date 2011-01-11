class ComputationPlatform < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :data_center_company, :foreign_key => 'data_center_company_name'
  
  data_miner do
    tap "Brighter Planet's computation platform data", Earth.taps_server
  end
end
