class Airline < ActiveRecord::Base
  set_primary_key :name

  force_schema do
    string 'name'
    string 'bts_code'
    string 'iata_code'
    string 'icao_code'
  end
end
