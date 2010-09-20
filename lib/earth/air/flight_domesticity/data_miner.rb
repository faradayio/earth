FlightDomesticity.class_eval do
  data_miner do
    process "Start from scratch" do
      connection.drop_table table_name
    end
    
    schema Earth.database_options do
      string 'name'
      string 'bts_data_source_code'
      float  'distance'
      string 'distance_units'
      float  'freight_share'
      float  'load_factor'
      float  'seats'
      float  'payload'
      string 'payload_units'
    end
    
    process "Derive flight domesticities from flight segments" do # FIXME TODO might make more sense to combine foreign and domestic carriers -> domestic flight (all carriers), international flight (all carriers)
      FlightSegment.run_data_miner!
      connection.execute %{
        INSERT IGNORE INTO flight_domesticities(name, bts_data_source_code)
        SELECT flight_segments.domesticity_id, flight_segments.bts_data_source_code FROM flight_segments WHERE LENGTH(flight_segments.domesticity_id) > 0
      }
    end
    
    process "Derive average flight characteristics from flight segments" do
      FlightSegment.run_data_miner!
      segments = FlightSegment.arel_table
      flight_domesticities = FlightDomesticity.arel_table
      ## slow, all-in-one method
      # conditional_relation = flight_domesticities[:name].eq(segments[:domesticity_id])
      # update_all "seats         = (#{FlightSegment.weighted_average_relation(:seats,         :weighted_by => :passengers                                           ).where(conditional_relation).to_sql})"
      # update_all "distance      = (#{FlightSegment.weighted_average_relation(:distance,      :weighted_by => :passengers                                           ).where(conditional_relation).to_sql})"
      # update_all "load_factor   = (#{FlightSegment.weighted_average_relation(:load_factor,   :weighted_by => :passengers                                           ).where(conditional_relation).to_sql})"
      # update_all "freight_share = (#{FlightSegment.weighted_average_relation(:freight_share, :weighted_by => :passengers                                           ).where(conditional_relation).to_sql})"
      # update_all "payload       = (#{FlightSegment.weighted_average_relation(:payload,       :weighted_by => :passengers, :disaggregate_by => :departures_performed).where(conditional_relation).to_sql})"
      ## fast method using temp tables
      find_in_batches do |batch|
        batch.each do |flight_domesticity|
          targeting_relation = flight_domesticities[:name].eq flight_domesticity.name
          conditional_relation = segments[:domesticity_id].eq flight_domesticity.name
          connection.execute "CREATE TEMPORARY TABLE tmp1 #{FlightSegment.where(conditional_relation).to_sql}"
          update_all "seats                    = (#{FlightSegment.weighted_average_relation(:seats,         :weighted_by => :passengers                                           ).to_sql.gsub('flight_segments', 'tmp1')})", targeting_relation.to_sql
          update_all "distance                 = (#{FlightSegment.weighted_average_relation(:distance,      :weighted_by => :passengers                                           ).to_sql.gsub('flight_segments', 'tmp1')})", targeting_relation.to_sql
          update_all "load_factor              = (#{FlightSegment.weighted_average_relation(:load_factor,   :weighted_by => :passengers                                           ).to_sql.gsub('flight_segments', 'tmp1')})", targeting_relation.to_sql
          update_all "freight_share            = (#{FlightSegment.weighted_average_relation(:freight_share, :weighted_by => :passengers                                           ).to_sql.gsub('flight_segments', 'tmp1')})", targeting_relation.to_sql
          update_all "payload                  = (#{FlightSegment.weighted_average_relation(:payload,       :weighted_by => :passengers, :disaggregate_by => :departures_performed).to_sql.gsub('flight_segments', 'tmp1')})", targeting_relation.to_sql
          connection.execute 'DROP TABLE tmp1'
        end
      end
      update_all "distance_units = 'kilometres'"
      update_all "payload_units  = 'kilograms'"
    end
  end
end

