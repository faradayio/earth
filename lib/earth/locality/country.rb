class Country < ActiveRecord::Base
  set_primary_key :iso_3166_code
  
  data_miner do
    tap "Brighter Planet's sanitized countries list", Earth.taps_server
  end
  
  class << self
    def united_states
      find_by_iso_3166_code('US')
    end
  end
end
