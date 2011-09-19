class PetroleumAdministrationForDefenseDistrict < ActiveRecord::Base
  set_primary_key :code
  set_table_name :petroleum_districts
  
  def name
    str = "PAD District #{district_code} (#{district_name})"
    str << " Subdistrict #{district_code}#{subdistrict_code} (#{subdistrict_name})" if subdistrict_code
    str
  end
  
  col :code
  col :district_code
  col :district_name
  col :subdistrict_code
  col :subdistrict_name
end