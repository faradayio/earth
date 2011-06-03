class Airport < ActiveRecord::Base
  set_primary_key :iata_code
  
  belongs_to :country, :foreign_key => 'country_iso_3166_code', :primary_key => 'iso_3166_code'
  
  acts_as_mappable :default_units => :nms,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude
  
  data_miner do
    tap "Brighter Planet's sanitized airports data", Earth.taps_server
    
    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
end
