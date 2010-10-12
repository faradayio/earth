class Country < ActiveRecord::Base
  set_primary_key :iso_3166_code
  
  falls_back_on :flight_route_inefficiency_factor => 1.10 # for international flights - this is the larger (European) factor from Kettunen et al. (2005) http://www.atmseminar.org/seminarContent/seminar6/papers/p_055_MPM.pdf
  
  data_miner do
    tap "Brighter Planet's sanitized countries list", Earth.taps_server
  end
  
  class << self
    def united_states
      find_by_iso_3166_code('US')
    end
  end
end
