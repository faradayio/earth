class BtsAircraftType < ActiveRecord::Base
  set_primary_key :bts_aircraft_type_code
  
  has_many :aircraft, :through => :aircraft_bts_aircraft_type
  
  data_miner do
    tap "Brighter Planet's sanitized BTS aircraft type data", Earth.taps_server
    
    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
end
