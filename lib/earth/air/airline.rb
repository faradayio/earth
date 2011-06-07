class Airline < ActiveRecord::Base
  set_primary_key :name

  create_table do
    string 'name'
    string 'bts_code'
    string 'iata_code'
    string 'icao_code'
  end
end
