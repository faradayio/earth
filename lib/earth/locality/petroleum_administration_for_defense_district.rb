require 'earth/model'

class PetroleumAdministrationForDefenseDistrict < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "petroleum_districts"
  (
     "code"             CHARACTER VARYING(255) NOT NULL,
     "district_code"    CHARACTER VARYING(255),
     "district_name"    CHARACTER VARYING(255),
     "subdistrict_code" CHARACTER VARYING(255),
     "subdistrict_name" CHARACTER VARYING(255)
  );
ALTER TABLE "petroleum_districts" ADD PRIMARY KEY ("code")
EOS

  self.primary_key = "code"
  self.table_name = :petroleum_districts
  
  def name
    str = "PAD District #{district_code} (#{district_name})"
    str << " Subdistrict #{district_code}#{subdistrict_code} (#{subdistrict_name})" if subdistrict_code
    str
  end
  

  warn_if_nulls_except(
    :subdistrict_code,
    :subdistrict_name
  )

  warn_unless_size 7
end
