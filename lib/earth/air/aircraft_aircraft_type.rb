class AircraftAircraftType < ActiveRecord::Base
  set_primary_key :row_hash
  
  belongs_to :aircraft,      :foreign_key => 'icao_code'
  belongs_to :aircraft_type, :foreign_key => 'aircraft_type_code'
  
  data_miner do
    tap "Brighter Planet's aircraft to BTS aircraft type dictionary", Earth.taps_server
    
    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
end
