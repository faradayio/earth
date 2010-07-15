class ResidenceAppliance < ActiveRecord::Base
  set_primary_key :name

  data_miner do
    tap "Brighter Planet's residence appliance energy information", Earth.taps_server
  end
end
