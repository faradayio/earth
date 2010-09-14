LodgingClass.class_eval do
  data_miner do
    schema Earth.database_options do
      string 'name'
      float  'natural_gas_intensity'
      string 'natural_gas_intensity_units'
      float  'fuel_oil_intensity'
      string 'fuel_oil_intensity_units'
      float  'electricity_intensity'
      string 'electricity_intensity_units'
      float  'district_heat_intensity'
      string 'district_heat_intensity_units'
    end
    
    process "Define some unit conversions" do
      Conversions.register :hundred_cubic_feet_per_room_night, :cubic_metres_per_room_night,        2.831685
      Conversions.register :gallons_per_room_night,            :litres_per_room_night,              3.785412
      Conversions.register :thousand_btu_per_room_night,       :joules_per_room_night,      1_055_056
    end
    
    import "a list of lodging classes and pre-calculated emission factors",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdGZZWmZtWEJlYzhRNXlPdWpBTldlcUE&hl=en&output=csv' do
      key   'name'
      store 'natural_gas_intensity', :from_units => :hundred_cubic_feet_per_room_night, :to_units => :cubic_metres_per_room_night
      store 'fuel_oil_intensity', :from_units => :gallons_per_room_night, :to_units => :litres_per_room_night
      store 'electricity_intensity', :units_field_name => 'electricity_intensity_units'
      store 'district_heat_intensity', :from_units => :thousand_btu_per_room_night, :to_units => :joules_per_room_night
    end
  end
end
