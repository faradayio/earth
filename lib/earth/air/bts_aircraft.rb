class BtsAircraft < ActiveRecord::Base
  set_primary_key :bts_code
  col :bts_code
  col :description
end