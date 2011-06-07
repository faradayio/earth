class PetroleumAdministrationForDefenseDistrict < ActiveRecord::Base
  set_primary_key :code
  set_table_name :petroleum_districts
  
  def name
    str = "PAD District #{district_code} (#{district_name})"
    str << " Subdistrict #{district_code}#{subdistrict_code} (#{subdistrict_name})" if subdistrict_code
    str
  end
  
  create_table do
    string   'code'
    string   'district_code'
    string   'district_name'
    string   'subdistrict_code'
    string   'subdistrict_name'
  end
end
