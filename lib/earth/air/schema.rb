Earth::Database.define_schema do
  create_table "aircraft", :primary_key => "icao_code", :id => false, :force => true do |t|
    t.string 'icao_code'
    t.string   "manufacturer_name"
    t.string   "name"
    t.string   "bts_name"
    t.string   "bts_aircraft_type_code"
    t.string   "brighter_planet_aircraft_class_code"
    t.string   "fuel_use_aircraft_name"
    t.float    "m3"
    t.float    "m2"
    t.float    "m1"
    t.float    "endpoint_fuel"
    t.float    "seats"
    t.float    "distance"
    t.float    "load_factor"
    t.float    "freight_share"
    t.float    "payload"
    t.float    "weighting"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "aircraft_classes", :primary_key => "brighter_planet_aircraft_class_code", :id => false, :force => true do |t|
    t.string 'brighter_planet_aircraft_class_code'
    t.string   "name"
    t.float    "m1"
    t.float    "m2"
    t.float    "m3"
    t.float    "endpoint_fuel"
    t.integer  "seats"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "aircraft_manufacturers", :primary_key => "name", :id => false, :force => true do |t|
    t.string 'name'
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "airlines", :primary_key => "iata_code", :id => false, :force => true do |t|
    t.string 'iata_code'
    t.string   "name"
    t.string   "dot_airline_id_code"
    t.boolean  "international"
    t.float    "distance"
    t.float    "load_factor"
    t.float    "freight_share"
    t.float    "payload"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "seats"
  end

  create_table "airports", :primary_key => "iata_code", :id => false, :force => true do |t|
    t.string 'iata_code'
    t.string   "name"
    t.string   "city"
    t.string   "country_name"
    t.string   "country_iso_3166_code"
    t.float    "latitude"
    t.float    "longitude"
    t.float    "seats"
    t.float    "distance"
    t.float    "load_factor"
    t.float    "freight_share"
    t.float    "payload"
    t.boolean  "international_origin"
    t.boolean  "international_destination"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flight_aircraft", :force => true do |t|
    t.string   "name"
    t.integer  "seats"
    t.integer  "flight_fuel_type_id"
    t.float    "endpoint_fuel"
    t.integer  "flight_manufacturer_id"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.date     "bts_begin_date"
    t.date     "bts_end_date"
    t.float    "load_factor"
    t.float    "freight_share"
    t.float    "m3"
    t.float    "m2"
    t.float    "m1"
    t.float    "distance"
    t.float    "payload"
    t.integer  "flight_aircraft_class_id"
    t.float    "multiplier"
    t.string   "manufacturer_name"
    t.string   "brighter_planet_aircraft_class_code"
    t.integer  "weighting"
    t.integer  "bts_aircraft_type"
  end

  create_table "flight_aircraft_classes", :force => true do |t|
    t.string  "name"
    t.integer "seats"
    t.integer "flight_fuel_type_id"
    t.float   "endpoint_fuel"
    t.string  "brighter_planet_aircraft_class_code"
    t.float   "m1"
    t.float   "m2"
    t.float   "m3"
  end

  create_table "flight_aircraft_seat_classes", :force => true do |t|
    t.integer  "flight_aircraft_id"
    t.integer  "flight_seat_class_id"
    t.integer  "seats"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "multiplier"
    t.boolean  "fresh"
  end

  create_table "flight_airline_aircraft", :force => true do |t|
    t.integer  "flight_airline_id"
    t.integer  "flight_aircraft_id"
    t.integer  "seats"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.float    "total_seat_area"
    t.float    "average_seat_area"
    t.boolean  "fresh"
    t.float    "multiplier"
  end

  create_table "flight_airline_aircraft_seat_classes", :force => true do |t|
    t.integer  "seats"
    t.float    "pitch"
    t.float    "width"
    t.float    "multiplier"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "seat_area"
    t.string   "name"
    t.integer  "flight_airline_id"
    t.integer  "flight_aircraft_id"
    t.integer  "flight_seat_class_id"
    t.integer  "weighting"
    t.integer  "peers"
  end

  create_table "flight_airline_seat_classes", :force => true do |t|
    t.integer  "flight_seat_class_id"
    t.integer  "flight_airline_id"
    t.float    "multiplier"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "seats"
    t.boolean  "fresh"
  end

  create_table "flight_airlines", :force => true do |t|
    t.string  "name"
    t.string  "iata"
    t.string  "us_dot_airline_id"
    t.float   "load_factor"
    t.float   "freight_share"
    t.float   "distance"
    t.float   "multiplier"
    t.integer "seats"
    t.float   "payload"
    t.boolean "international"
  end

  create_table "flight_configurations", :primary_key => "name", :id => false, :force => true do |t|
    t.string 'name'
    t.string   "bts_aircraft_configuration_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flight_distance_classes", :primary_key => "name", :id => false, :force => true do |t|
    t.string 'name'
    t.float    "distance"
    t.string   "distance_units"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "flight_domesticities", :primary_key => "name", :id => false, :force => true do |t|
    t.string 'name'
    t.string   "bts_data_source_code"
    t.float    "distance"
    t.string   "distance_units"
    t.float    "freight_share"
    t.float    "load_factor"
    t.float    "seats"
    t.float    "payload"
    t.string   "payload_units"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flight_fuel_types", :force => true do |t|
    t.string   "name"
    t.float    "emission_factor"
    t.float    "radiative_forcing_index"
    t.float    "density"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flight_manufacturers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flight_patterns", :force => true do |t|
    t.string   "name"
    t.integer  "flight_id"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "monthly_flights"
    t.integer  "profile_id"
  end

  create_table "flight_propulsions", :primary_key => "name", :id => false, :force => true do |t|
    t.string 'name'
    t.string   "bts_aircraft_group_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flight_seat_classes", :primary_key => "name", :id => false, :force => true do |t|
    t.string 'name'
    t.float    "multiplier"
    t.integer  "seats"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "flight_segments", :primary_key => "row_hash", :id => false, :force => true do |t|
    t.string 'row_hash'
    t.string   "propulsion_id"
    t.integer  "bts_aircraft_group_code"
    t.string   "configuration_id"
    t.integer  "bts_aircraft_configuration_code"
    t.string   "distance_group"
    t.integer  "bts_distance_group_code"
    t.string   "service_class_id"
    t.string   "bts_service_class_code"
    t.string   "domesticity_id"
    t.string   "bts_data_source_code"
    t.integer  "departures_performed"
    t.integer  "payload"
    t.integer  "total_seats"
    t.integer  "passengers"
    t.integer  "freight"
    t.integer  "mail"
    t.integer  "ramp_to_ramp"
    t.integer  "air_time"
    t.float    "load_factor"
    t.float    "freight_share"
    t.integer  "distance"
    t.integer  "departures_scheduled"
    t.string   "airline_iata_code"
    t.string   "dot_airline_id_code"
    t.string   "unique_carrier_name"
    t.string   "unique_carrier_entity"
    t.string   "region"
    t.string   "current_airline_iata_code"
    t.string   "carrier_name"
    t.integer  "carrier_group"
    t.integer  "carrier_group_new"
    t.string   "origin_airport_iata_code"
    t.string   "origin_city_name"
    t.integer  "origin_city_num"
    t.string   "origin_state_abr"
    t.string   "origin_state_fips"
    t.string   "origin_state_nm"
    t.string   "origin_country_iso_3166_code"
    t.string   "origin_country_name"
    t.integer  "origin_wac"
    t.string   "dest_airport_iata_code"
    t.string   "dest_city_name"
    t.integer  "dest_city_num"
    t.string   "dest_state_abr"
    t.string   "dest_state_fips"
    t.string   "dest_state_nm"
    t.string   "dest_country_iso_3166_code"
    t.string   "dest_country_name"
    t.integer  "dest_wac"
    t.integer  "bts_aircraft_type_code"
    t.integer  "year"
    t.integer  "quarter"
    t.integer  "month"
    t.float    "seats"
    t.string   "payload_units"
    t.string   "freight_units"
    t.string   "mail_units"
    t.string   "distance_units"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flight_services", :primary_key => "name", :id => false, :force => true do |t|
    t.string 'name'
    t.string   "bts_service_class_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flight_records", :force => true do |t|
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "distance_estimate"
    t.integer  "seats_estimate"
    t.float    "load_factor"
    t.time     "time_of_day"
    t.integer  "year"
    t.integer  "emplanements_per_trip"
    t.integer  "trips"
    t.string   "origin_airport_id"
    t.string   "destination_airport_id"
    t.string   "distance_class_id"
    t.string   "aircraft_id"
    t.string   "aircraft_class_id"
    t.string   "propulsion_id"
    t.string   "fuel_type_id"
    t.string   "airline_id"
    t.string   "seat_class_id"
    t.string   "domesticity_id"
  end
end
