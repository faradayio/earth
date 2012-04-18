require 'earth/fuel/data_miner'
CensusDivision.class_eval do
  data_miner do
    # http://www.census.gov/popest/geographic/codes02.csv
    import('the U.S. Census Geographic Terms and Definitions',
           :url => 'http://www.census.gov/popest/about/geo/state_geocodes_v2009.txt',
           :skip => 6,
           :headers => %w{ Region Division FIPS Name },
           :select => proc { |row| row['Division'].to_i > 0 and row['FIPS'].to_i == 0 }) do
      key   'number', :field_name => 'Division'
      store 'name', :field_name => 'Name'
      store 'census_region_number', :field_name => 'Region'
      store 'census_region_name', :field_name => 'Region', :dictionary => { :input => 'number', :output => 'name', :url => 'http://data.brighterplanet.com/census_regions.csv' }
    end
    
    import 'meeting building fuel intensities calculated from CBECS 2003',
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdGotdjgtUEk0eUU0R3lxM1hHdlF1V0E&hl=en&gid=0&output=csv' do
      key   'number', :field_name => 'census_division'
      store 'meeting_building_natural_gas_intensity',   :from_units => :hundred_cubic_feet_per_square_foot_hour, :to_units => :cubic_metres_per_square_metre_hour
      store 'meeting_building_fuel_oil_intensity',      :from_units => :gallons_per_square_foot_hour,            :to_units => :litres_per_square_metre_hour
      store 'meeting_building_electricity_intensity',   :from_units => :kilowatt_hours_per_square_foot_hour,     :to_units => :kilowatt_hours_per_square_metre_hour
      store 'meeting_building_district_heat_intensity', :from_units => :kbtus_per_square_foot_hour,              :to_units => :megajoules_per_square_metre_hour
    end
  end
end
