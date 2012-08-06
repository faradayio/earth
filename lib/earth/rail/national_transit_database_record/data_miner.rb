NationalTransitDatabaseRecord.class_eval do
  data_miner do
    import "US National Transit Database service data",
           :url => "#{Earth::DATA_DIR}/rail/ntd_service.csv" do
      key 'name', :synthesize => proc { |row| [row['trs_id'], row['mode_code'], row['service_code']].join(' ') }
      store 'company_id', :field_name => 'trs_id'
      store 'mode_code'
      store 'service_type',       :field_name => 'service_code', :dictionary => { :input => 'code', :output => 'name', :url => 'https://docs.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdDBTZENxb3A1SzJaNTVEVGZ5cTdaMVE&output=csv' }
      store 'vehicle_distance',   :field_name => 'vehicle_or_train_revenue_miles', :from_units => :miles, :to_units => :kilometres
      store 'vehicle_time',       :field_name => 'vehicle_or_train_revenue_hours', :units => 'hours'
      store 'passenger_distance', :field_name => 'passenger_miles',                :from_units => :miles, :to_units => :kilometres
      store 'passengers'
    end
    
    import "US National Transit Database fuel consumption data",
           :url => "#{Earth::DATA_DIR}/rail/ntd_fuel_consumption.csv" do
      key 'name', :synthesize => proc { |row| [row['trs_id'], row['mode_code'], row['service_code']].join(' ') }
      store 'company_id', :field_name => 'trs_id'
      store 'mode_code'
      store 'service_type', :field_name => 'service_code', :dictionary => { :input => 'code', :output => 'name', :url => 'https://docs.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdDBTZENxb3A1SzJaNTVEVGZ5cTdaMVE&output=csv' }
      store 'electricity',  :synthesize => proc { |row| row['electricity_kwh'].to_f + row['battery_kwh'].to_f }, :units => 'kilowatt_hours'
      store 'diesel',       :field_name => 'diesel_gallons',    :from_units => :gallons, :to_units => :litres
      store 'gasoline',     :field_name => 'gasoline_gallons',  :from_units => :gallons, :to_units => :litres
      store 'lpg',          :field_name => 'lpg_gallons',       :from_units => :gallons, :to_units => :litres
      store 'lng',          :field_name => 'lng_gallons',       :from_units => :gallons, :to_units => :litres
      store 'cng',          :field_name => 'cng_gallons',       :from_units => :gallons, :to_units => :litres
      store 'kerosene',     :field_name => 'kerosene_gallons',  :from_units => :gallons, :to_units => :litres
      store 'biodiesel',    :field_name => 'biodiesel_gallons', :from_units => :gallons, :to_units => :litres
      store 'other_fuel'
      store 'other_fuel_description', :field_name => 'other_fuel_description'
    end
  end
end
