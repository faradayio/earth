class FlightSegment < ActiveRecord::Base
  set_primary_key :row_hash
  
  extend CohortScope
  self.minimum_cohort_size = 5 #FIXME ??
  
  belongs_to :airline,             :foreign_key => 'airline_iata_code'
  belongs_to :origin_airport,      :foreign_key => "origin_airport_iata_code",     :class_name => 'Airport'
  belongs_to :destination_airport, :foreign_key => "dest_airport_iata_code",       :class_name => 'Airport'
  belongs_to :origin_country,      :foreign_key => 'origin_country_iso_3166_code', :class_name => 'Country'
  belongs_to :destination_country, :foreign_key => 'dest_country_iso_3166_code',   :class_name => 'Country'
  belongs_to :aircraft,            :foreign_key => 'bts_aircraft_type_code',                                              :primary_key => 'bts_aircraft_type_code'
  belongs_to :propulsion,                                                          :class_name => 'FlightPropulsion'
  belongs_to :configuration,                                                       :class_name => 'FlightConfiguration'
  belongs_to :service_class,                                                       :class_name => 'FlightService'
  belongs_to :domesticity,                                                         :class_name => 'FlightDomesticity'
  
  falls_back_on :load_factor =>   lambda { weighted_average(:load_factor,   :weighted_by => :passengers) }, # 0.78222911236768
                :freight_share => lambda { weighted_average(:freight_share, :weighted_by => :passengers) },  # 0.024017329363736
                :seats => lambda { weighted_average :seats, :weighted_by => :passengers }

  data_miner do
    tap "Brighter Planet's sanitized T100 data", Earth.taps_server
    
    process "rename certain columns so that we can use them as association names" do
      connection.rename_column :flight_segments, :domesticity, :domesticity_id
      connection.rename_column :flight_segments, :service_class, :service_class_id
      connection.rename_column :flight_segments, :configuration, :configuration_id
      connection.rename_column :flight_segments, :propulsion, :propulsion_id
    end
    
    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end

  INPUT_CHARACTERISTICS = [
    :origin_airport,
    :destination_airport,
    :aircraft,
    :airline,
    :propulsion,
    :domesticity
  ]
end
