class PetroleumAdministrationForDefenseDistrict < ActiveRecord::Base
  set_primary_key :code
  set_table_name :petrolem_districts
  
  data_miner do
    tap "Brighter Planet's PADD info", Earth.taps_server
  end
  
  def name
    str = "PAD District #{district_code} (#{district_name})"
    str << " Subdistrict #{district_code}#{subdistrict_code} (#{subdistrict_name})" if subdistrict_code
    str
  end
end
