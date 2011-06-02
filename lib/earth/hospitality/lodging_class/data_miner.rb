LodgingClass.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      float  'electricity_intensity'
      string 'electricity_intensity'
      float  'natural_gas_intensity'
      string 'natural_gas_intensity'
      float  'fuel_oil_intensity'
      string 'fuel_oil_intensity'
      float  'district_heat_intensity'
      string 'district_heat_intensity'
    end
    
    import "a list of lodging classes and pre-calculated emission factors",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdGZZWmZtWEJlYzhRNXlPdWpBTldlcUE&hl=en&gid=0&output=csv' do
      key   'name'
      store 'natural_gas_intensity', :units_field_name => 'natural_gas_intensity_units'
      store 'fuel_oil_intensity', :units_field_name => 'fuel_oil_intensity_units'
      store 'electricity_intensity', :units_field_name => 'electricity_intensity_units'
      store 'district_heat_intensity', :units_field_name => 'district_heat_intensity_units'
    end
    
    process "Convert natural gas intensities to metric units" do
      conversion_factor = 2.83168466 # Google: 2.83168466 cubic m / 100 cubic ft
      update_all "natural_gas_intensity = natural_gas_intensity * #{conversion_factor} WHERE natural_gas_intensity_units = 'hundred_cubic_feet_per_room_night'"
      update_all "natural_gas_intensity_units = 'cubic_metres_per_room_night' WHERE natural_gas_intensity_units = 'hundred_cubic_feet_per_room_night'"
    end
    
    process "Convert fuel oil intensities to metric units" do
      conversion_factor = 3.78541178 # Google: 3.78541178 l / gal
      update_all "fuel_oil_intensity = fuel_oil_intensity * #{conversion_factor} WHERE fuel_oil_intensity_units = 'gallons_per_room_night'"
      update_all "fuel_oil_intensity_units = 'litres_per_room_night' WHERE fuel_oil_intensity_units = 'gallons_per_room_night'"
    end
    
    process "Convert district heat intensities to metric units" do
      conversion_factor = 1.05505585 # Google: 1.05505585 MJ / 1000 Btu
      update_all "district_heat_intensity = district_heat_intensity * #{conversion_factor} WHERE district_heat_intensity_units = 'thousand_btu_per_room_night'"
      update_all "district_heat_intensity_units = 'megajoules_per_room_night' WHERE district_heat_intensity_units = 'thousand_btu_per_room_night'"
    end
  end
end
