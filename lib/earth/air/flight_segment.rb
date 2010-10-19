class FlightSegment < ActiveRecord::Base
  set_primary_key :row_hash
  
  extend CohortScope
  self.minimum_cohort_size = 1
  
  belongs_to :airline,             :foreign_key => 'airline_iata_code'
  belongs_to :origin_airport,      :foreign_key => "origin_airport_iata_code",     :class_name => 'Airport'
  belongs_to :destination_airport, :foreign_key => "dest_airport_iata_code",       :class_name => 'Airport'
  belongs_to :origin_country,      :foreign_key => 'origin_country_iso_3166_code', :class_name => 'Country'
  belongs_to :destination_country, :foreign_key => 'dest_country_iso_3166_code',   :class_name => 'Country'
  belongs_to :aircraft_type,       :foreign_key => 'aircraft_type_code'
  # belongs_to :propulsion,                                                          :class_name => 'FlightPropulsion'
  # belongs_to :configuration,                                                       :class_name => 'FlightConfiguration'
  # belongs_to :service_class,                                                       :class_name => 'FlightService'
  # belongs_to :domesticity,                                                         :class_name => 'FlightDomesticity'
  
  falls_back_on :distance          => lambda { weighted_average(:distance,      :weighted_by => :passengers) }, # 2077.1205         data1 10-12-2010
                :seats             => lambda { weighted_average(:seats,         :weighted_by => :passengers) }, # 144.15653537046   data1 10-12-2010
                :load_factor       => lambda { weighted_average(:load_factor,   :weighted_by => :passengers) }, # 0.78073233770097  data1 10-12-2010
                :freight_share     => lambda { weighted_average(:freight_share, :weighted_by => :passengers) }  # 0.022567224170157 data1 10-12-2010
  
  data_miner do
    tap "Brighter Planet's sanitized T100 data", Earth.taps_server
    
    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
end
