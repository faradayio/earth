class PetroleumAdministrationForDefenseDistrict < ActiveRecord::Base
  set_primary_key :code
  
  data_miner do
    tap "Brighter Planet's PADD info", TAPS_SERVER
  end
  
  def name
    str = "PAD District #{district_code} (#{district_name})"
    str << " Subdistrict #{district_code}#{subdistrict_code} (#{subdistrict_name})" if subdistrict_code
    str
  end
end
