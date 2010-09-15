CensusDivision.class_eval do
  data_miner do
    schema Earth.database_options do
      integer 'number'
      string  'name'
      string  'census_region_name'
      integer 'census_region_number'
      float   'meeting_building_natural_gas_intensity'
      string  'meeting_building_natural_gas_intensity_units'
      float   'meeting_building_fuel_oil_intensity'
      string  'meeting_building_fuel_oil_intensity_units'
      float   'meeting_building_electricity_intensity'
      string  'meeting_building_electricity_intensity_units'
      float   'meeting_building_district_heat_intensity'
      string  'meeting_building_district_heat_intensity_units'
      float   'lodging_building_natural_gas_intensity'
      string  'lodging_building_natural_gas_intensity_units'
      float   'lodging_building_fuel_oil_intensity'
      string  'lodging_building_fuel_oil_intensity_units'
      float   'lodging_building_electricity_intensity'
      string  'lodging_building_electricity_intensity_units'
      float   'lodging_building_district_heat_intensity'
      string  'lodging_building_district_heat_intensity_units'
    end
    
    falls_back_on :meeting_building_natural_gas_intensity => 0.011973,
                  :meeting_building_fuel_oil_intensity => 0.0037381,
                  :meeting_building_electricity_intensity => 0.072444,
                  :meeting_building_district_heat_intensity => 3458.7
    
    import 'the U.S. Census Geographic Terms and Definitions',
           :url => 'http://www.census.gov/popest/geographic/codes02.csv',
           :skip => 9,
           :select => lambda { |row| row['Division'].to_s.strip != 'X' and row['FIPS CODE STATE'].to_s.strip == 'X'} do
      key   'number', :field_name => 'Division'
      store 'name', :field_name => 'Name'
      store 'census_region_number', :field_name => 'Region'
      store 'census_region_name', :field_name => 'Region', :dictionary => { :input => 'number', :output => 'name', :url => 'http://data.brighterplanet.com/census_regions.csv' }
    end
    
    process 'Define some unit conversions' do
      Conversions.register :hundred_cubic_feet_per_square_foot_hour, :cubic_metres_per_square_metre_hour,   30.48
      Conversions.register :gallons_per_square_foot_hour,            :litres_per_square_metre_hour,         40.745833
      Conversions.register :kilowatt_hours_per_square_foot_hour,     :kilowatt_hours_per_square_metre_hour, 10.76391
      Conversions.register :thousand_btu_per_square_foot_hour,       :joules_per_square_metre_hour, 11_356_527
      Conversions.register :hundred_cubic_feet_per_room_night,       :cubic_metres_per_room_night,           2.8317
      Conversions.register :gallons_per_room_night,                  :litres_per_room_night,                 3.7854
      Conversions.register :thousand_btu_per_room_night,             :joules_per_room_night,         1_055_056
    end
    
    import 'meeting building fuel intensities calculated from CBECS 2003',
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdGotdjgtUEk0eUU0R3lxM1hHdlF1V0E&hl=en&output=csv' do
      key   'number', :field_name => 'census_division'
      store 'meeting_building_natural_gas_intensity', :from_units => :hundred_cubic_feet_per_square_foot_hour, :to_units => :cubic_metres_per_square_metre_hour
      store 'meeting_building_fuel_oil_intensity', :from_units => :gallons_per_square_foot_hour, :to_units => :litres_per_square_metre_hour
      store 'meeting_building_electricity_intensity', :from_units => :kilowatt_hours_per_square_foot_hour, :to_units => :kilowatt_hours_per_square_metre_hour
      store 'meeting_building_district_heat_intensity', :from_units => :thousand_btu_per_square_foot_hour, :to_units => :joules_per_square_metre_hour
    end
    
    import 'lodging building fuel intensities calculated from CBECS 2003',
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdHZ1QjdNTGVpbWxmZDVLbjlpTHlFVHc&hl=en&output=csv' do
      key   'number', :field_name => 'census_division'
      store 'lodging_building_natural_gas_intensity', :from_units => :hundred_cubic_feet_per_room_night, :to_units => :cubic_metres_per_room_night
      store 'lodging_building_fuel_oil_intensity', :from_units => :gallons_per_room_night, :to_units => :litres_per_room_night
      store 'lodging_building_electricity_intensity', :units_field_name => 'lodging_building_electricity_intensity_units'
      store 'lodging_building_district_heat_intensity', :from_units => :thousand_btu_per_room_night, :to_units => :joules_per_room_night
    end
  end
end
