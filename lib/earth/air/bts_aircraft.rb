class BtsAircraft < ActiveRecord::Base
  set_primary_key :bts_code
  create_table do
    string 'bts_code'
    string 'description'
  end
end
