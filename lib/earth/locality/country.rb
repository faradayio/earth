class Country < ActiveRecord::Base
  set_primary_key :iso_3166_code
  
  extend Cacheable if Switches.caching?
  
  data_miner do
    tap "Brighter Planet's sanitized countries list", TAPS_SERVER
  end
  
  class << self
    def united_states
      find_by_iso_3166_code('US')
    end
    cacheify :united_states if Switches.caching?
  end
end
