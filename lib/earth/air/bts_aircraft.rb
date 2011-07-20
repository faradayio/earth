class BtsAircraft < ActiveRecord::Base
  set_primary_key :bts_code
  force_schema do
    string 'bts_code'
    string 'description'
  end
end
