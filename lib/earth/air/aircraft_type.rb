class AircraftType < ActiveRecord::Base
  set_primary_key :aircraft_type_code
  
  has_many :segments, :foreign_key => 'aircraft_type_code', :class_name => 'FlightSegment'
  has_many :aircraft, :through => :aircraft_aircraft_types
  
  data_miner do
    tap "Brighter Planet's sanitized BTS aircraft type data", Earth.taps_server
    
    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
end
