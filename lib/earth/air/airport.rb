class Airport < ActiveRecord::Base
  set_primary_key :iata_code
  index :iata_code
  
  class << self
    def loose_search_columns
      @_loose_search_columns ||= [primary_key, :city]
    end

    # search by name
    def loose_right_reader
      @_loose_right_reader ||= lambda { |record| record[1] }
    end
  end
  
  def name_and_location
    [ name.to_s.titleize, city, country.andand.name ].select(&:present?).join ', '
  end
  
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
  def segments
    FlightSegment.scoped :conditions => ['origin_airport_id = ? OR destination_airport_id = ?', id, id]
  end
  # --------------------------------
  
  belongs_to :country, :foreign_key => 'country_iso_3166_code'
  acts_as_mappable :default_units => :nms,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  data_miner do
    tap "Brighter Planet's sanitized airports data", TAPS_SERVER
    
    process "pull dependencies" do
      run_data_miner_on_belongs_to_associations
    end
  end
  
  def all_flights_from_here_domestic?
    !international_origin?
  end

  def all_flights_to_here_domestic?
    !international_destination?
  end
  
  def united_states?
    country == Country.united_states
  end
end
