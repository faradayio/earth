require 'earth/fuel/data_miner'
require 'earth/locality/data_miner'
RailCompany.class_eval do
  data_miner do
    import "european rail company data from the UIC",
           :url => 'https://docs.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdDRpVkd3T0p1RDY4RzUzc0VUUVEwYmc&output=csv' do
      key   'name'
      store 'country_iso_3166_code'
      store 'passengers',         :nullify => true
      store 'passenger_distance', :nullify => true, :units_field_name => 'passenger_distance_units'
      store 'train_distance',     :nullify => true, :units_field_name => 'train_distance_units'
    end
    
    import "Amtrak data",
           :url => 'https://docs.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdGZ3UDdJT1NETUtELWVTLUR4R3RZbEE&output=csv' do
      key   'name'
      store 'country_iso_3166_code'
      store 'passengers',            :nullify => true
      store 'passenger_distance',    :nullify => true, :units_field_name => 'passenger_distance_units'
      store 'train_distance',        :nullify => true, :units_field_name => 'train_distance_units'
      store 'train_time',            :nullify => true, :units_field_name => 'train_time_units'
      store 'electricity_intensity', :nullify => true, :units_field_name => 'electricity_intensity_units'
      store 'diesel_intensity',      :nullify => true, :units_field_name => 'diesel_intensity_units'
    end
    
    process "Ensure the National Transit Database data is imported" do
      NationalTransitDatabaseRecord.run_data_miner!
      NationalTransitDatabaseCompany.run_data_miner!
      NationalTransitDatabaseMode.run_data_miner!
    end
    
    process "Derive US transit rail company data from the National Transit Database" do
      NationalTransitDatabaseCompany.rail_companies.each do |ntd_company|
        company = find_or_create_by_name(ntd_company.name)
        company.country_iso_3166_code    = 'US'
        company.duns_number              = ntd_company.duns_number
        company.passengers               = ntd_company.rail_passengers
        company.passenger_distance       = ntd_company.rail_passenger_distance
        company.passenger_distance_units = ntd_company.rail_passenger_distance_units
        company.train_distance           = ntd_company.rail_vehicle_distance
        company.train_distance_units     = ntd_company.rail_vehicle_distance_units
        company.train_time               = ntd_company.rail_vehicle_time
        company.train_time_units         = ntd_company.rail_vehicle_time_units
        
        if ntd_company.rail_electricity.present? and ntd_company.rail_electricity > 0 and ntd_company.rail_passenger_distance > 0
          company.electricity_intensity = ntd_company.rail_electricity / ntd_company.rail_passenger_distance
          company.electricity_intensity_units = "#{ntd_company.rail_electricity_units}_per_passenger_#{ntd_company.rail_passenger_distance_units.singularize}"
        end
        
        if ntd_company.rail_diesel.present? and ntd_company.rail_diesel > 0 and ntd_company.rail_passenger_distance > 0
          company.diesel_intensity = ntd_company.rail_diesel / ntd_company.rail_passenger_distance
          company.diesel_intensity_units = "#{ntd_company.rail_diesel_units}_per_passenger_#{ntd_company.rail_passenger_distance_units.singularize}"
        end
        
        company.save!
      end
    end
    
    process "Calculate average trip distance" do
      find_each do |company|
        if company.passenger_distance.present? and company.passengers.present? and company.passengers > 0
          company.trip_distance = company.passenger_distance / company.passengers
          company.trip_distance_units = company.passenger_distance_units
          company.save!
        end
      end
    end
    
    process "Calculate average trip speed" do
      find_each do |company|
        if company.train_distance.present? and company.train_time.present? and company.train_time > 0
          company.speed = company.train_distance / company.train_time
          company.speed_units = "#{company.train_distance_units}_per_#{company.train_time_units.singularize}"
          company.save!
        end
      end
    end
    
    process "Ensure RailFuel and EgridSubregion are populated" do
      RailFuel.run_data_miner!
      EgridSubregion.run_data_miner!
    end
    
    process "Calculate co2 emission factor for US rail companies" do
      where(:country_iso_3166_code => 'US').find_each do |company|
        company.co2_emission_factor = 0
        
        if company.diesel_intensity.present?
          company.co2_emission_factor += company.diesel_intensity * RailFuel.find_by_name("diesel").co2_emission_factor
        end
        
        if company.electricity_intensity.present?
          company.co2_emission_factor += company.electricity_intensity * (EgridSubregion.fallback.co2_emission_factor / (1 - EgridRegion.fallback.loss_factor))
        end
        
        company.co2_emission_factor_units = 'kilograms_per_passenger_kilometre'
        company.save!
      end
    end
  end
end
