class BtsAircraft < ActiveRecord::Base
  self.primary_key = :bts_code
  col :bts_code
  col :description
end
