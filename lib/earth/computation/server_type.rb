class ServerType < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :data_center_company, :foreign_key => 'data_center_company_name'
  
  data_miner do
    tap "Brighter Planet's server type data", Earth.taps_server
  end
end
