class ServerTypeAlias < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :server_type, :foreign_key => 'server_type_name'
  belongs_to :platform,    :foreign_key => 'platform_name',   :class_name => 'ComputationPlatform'
  
  data_miner do
    tap "Brighter Planet's server type data", Earth.taps_server
  end
end
