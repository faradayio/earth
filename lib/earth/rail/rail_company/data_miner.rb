RailCompany.class_eval do
  data_miner do
    import "rail company data from the UIC",
           :url => 'https://docs.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdDRpVkd3T0p1RDY4RzUzc0VUUVEwYmc&output=csv' do
      key   'name'
      store 'country_iso_3166_code'
      store 'passengers',            :nullify => true
      store 'passenger_distance',    :nullify => true, :units_field_name => 'passenger_distance_units'
      store 'train_distance',        :nullify => true, :units_field_name => 'train_distance_units'
      store 'train_time',            :nullify => true, :units_field_name => 'train_time_units'
      store 'electricity_intensity', :nullify => true, :units_field_name => 'electricity_intensity_units'
      store 'diesel_intensity',      :nullify => true, :units_field_name => 'diesel_intensity_units'
      store 'emission_factor',       :nullify => true, :units_field_name => 'emission_factor_units'
    end
    
    process "Ensure the National Transit Database data is imported" do
      NationalTransitDatabaseRecord.run_data_miner!
      NationalTransitDatabaseCompany.run_data_miner!
      NationalTransitDatabaseMode.run_data_miner!
    end
    
    process "Import US transit rail company data from the National Transit Database" do
      NationalTransitDatabaseCompany.find_each do |transit_company|
        if transit_company.rail_company?
          company = RailCompany.find_or_create_by_name(transit_company.name)
          company.country_iso_3166_code    = 'US'
          company.duns_number              = transit_company.duns_number
          company.passengers               = transit_company.rail_passengers
          company.passenger_distance       = transit_company.rail_passenger_distance
          company.passenger_distance_units = transit_company.rail_passenger_distance_units
          company.train_distance           = transit_company.rail_vehicle_distance
          company.train_distance_units     = transit_company.rail_vehicle_distance_units
          company.train_time               = transit_company.rail_vehicle_time
          company.train_time_units         = transit_company.rail_vehicle_time_units
          
          if transit_company.rail_electricity.present? and transit_company.rail_electricity > 0 and transit_company.rail_passenger_distance > 0
            company.electricity_intensity = transit_company.rail_electricity / transit_company.rail_passenger_distance
            company.electricity_intensity_units = "#{transit_company.rail_electricity_units}_per_passenger_#{transit_company.rail_passenger_distance_units.singularize}"
          end
          
          if transit_company.rail_diesel.present? and transit_company.rail_diesel > 0 and transit_company.rail_passenger_distance > 0
            company.diesel_intensity = transit_company.rail_diesel / transit_company.rail_passenger_distance
            company.diesel_intensity_units = "#{transit_company.rail_diesel_units}_per_passenger_#{transit_company.rail_passenger_distance_units.singularize}"
          end
          
          company.save!
        end
      end
    end
    
    process "Calculate average trip distance" do
      RailCompany.find_each do |company|
        if company.passenger_distance.present? and company.passengers.present? and company.passengers > 0
          company.trip_distance = company.passenger_distance / company.passengers
          company.trip_distance_units = company.passenger_distance_units
          company.save!
        end
      end
    end
    
    process "Calculate average trip speed" do
      RailCompany.find_each do |company|
        if company.train_distance.present? and company.train_time.present? and company.train_time > 0
          company.speed = company.train_distance / company.train_time
          company.speed_units = "#{company.train_distance_units}_per_#{company.train_time_units}"
          company.save!
        end
      end
    end
    
    process "Calculate emission factor for US rail companies" do
      
    end
  end
end
