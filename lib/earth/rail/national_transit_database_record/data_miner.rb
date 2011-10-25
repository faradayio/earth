NationalTransitDatabaseRecord.class_eval do
  data_miner do
    import "US National Transit Database service data",
           :url => 'https://docs.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdF9Hbktvc3BMNDRWZHhDRU9uMVZfWVE&output=csv' do
      key 'name', :synthesize => lambda { |row| [row['trs_id'], row['mode_code'], row['service_code']].join(' ') }
      store 'company_id', :field_name => 'trs_id'
      store 'mode_code'
      store 'service_type',       :field_name => 'service_code', :dictionary => { :input => 'code', :output => 'name', :url => 'https://docs.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdDBTZENxb3A1SzJaNTVEVGZ5cTdaMVE&output=csv' }
      store 'vehicle_distance',   :field_name => 'vehicle_or_train_revenue_miles', :units => 'miles'
      store 'vehicle_time',       :field_name => 'vehicle_or_train_revenue_hours', :units => 'hours'
      store 'passenger_distance', :field_name => 'passenger_miles',                :units => 'miles'
      store 'passengers'
    end
    
    import "US National Transit Database fuel consumption data",
           :url => 'https://docs.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdDItVVR5NjA2Y3FCVjgza25Ccy0zS2c&output=csv' do
      key 'name', :synthesize => lambda { |row| [row['trs_id'], row['mode_code'], row['service_code']].join(' ') }
      store 'company_id', :field_name => 'trs_id'
      store 'mode_code'
      store 'service_type', :field_name => 'service_code', :dictionary => { :input => 'code', :output => 'name', :url => 'https://docs.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdDBTZENxb3A1SzJaNTVEVGZ5cTdaMVE&output=csv' }
      store 'electricity',  :synthesize => lambda { |row| row['electricity_kwh'].to_f + row['battery_kwh'].to_f }, :units => 'kilowatt_hours', :nullify => true
      store 'diesel',       :field_name => 'diesel_gallons',    :units => 'gallons', :nullify => true
      store 'gasoline',     :field_name => 'gasoline_gallons',  :units => 'gallons', :nullify => true
      store 'lpg',          :field_name => 'lpg_gallons',       :units => 'gallons', :nullify => true
      store 'lng',          :field_name => 'lng_gallons',       :units => 'gallons', :nullify => true
      store 'cng',          :field_name => 'cng_gallons',       :units => 'gallons', :nullify => true
      store 'kerosene',     :field_name => 'kerosene_gallons',  :units => 'gallons', :nullify => true
      store 'biodiesel',    :field_name => 'biodiesel_gallons', :units => 'gallons', :nullify => true
      store 'other_fuel',                                                            :nullify => true
      store 'other_fuel_description', :field_name => 'other_fuel_description',       :nullify => true
    end
    
    process "Convert miles to kilometres" do
      conversion_factor = 1.miles.to(:kilometres)
      %w{ vehicle_distance passenger_distance }.each do |field|
        where("#{field}_units" => 'miles').update_all(%{
          #{field} = 1.0 * #{field} * #{conversion_factor},
          #{field}_units = 'kilometres'
        })
      end
    end
      
    process "Convert gallons to litres" do
      conversion_factor = 1.gallons.to(:litres)
      %w{ diesel gasoline lpg lng cng kerosene biodiesel }.each do |fuel|
        where("#{fuel}_units" => 'gallons').update_all(%{
          #{fuel} = 1.0 * #{fuel} * #{conversion_factor},
          #{fuel}_units = 'litres'
        })
      end
    end
  end
end
