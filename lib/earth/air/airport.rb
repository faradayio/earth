class Airport < ActiveRecord::Base
  set_primary_key :iata_code
  
  # --------------------------------
  # virtual has_many association
  # has_many :segments won't work because there's no general way to specify the correct conditions
  # even if you get clever with it, like
  # has_many  :segments,
  #           :class_name => 'FlightSegment',
  #           :foreign_key => 'origin_airport_id',
  #           :conditions => 'flight_segments.destination_airport_id = #{id}'
  # you get queries like "`flight_segments`.origin_airport_id = 3654 AND (flight_segments.destination_airport_id = 3654))"
  # in which you notice the AND which must be an OR
  # and you can't just do finder_sql, because that breaks any other :select
  def flight_segments
    FlightSegment.where(%{
           origin_airport_iata_code = :iata
        OR destination_airport_iata_code = :iata
        OR origin_airport_city = :city
        OR destination_airport_city = :city
      }, :iata => iata_code, :city => city)
  end
  # --------------------------------
  
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
