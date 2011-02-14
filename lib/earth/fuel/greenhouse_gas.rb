class GreenhouseGas < ActiveRecord::Base
  set_primary_key :name
  
  data_miner do
    tap "Brighter Planet's greenhouse gas data", Earth.taps_server
  end
  
  class << self
    def [](abbreviation)
      find_by_abbreviation abbreviation.to_s
    end
  end
end
