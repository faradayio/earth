LodgingClass.class_eval do
  data_miner do
    # DEPRECATED - once new Lodging is phased in replace this with an import of lodging class names from the CountryLodgingClass google doc
    import "a list of lodging classes and pre-calculated energy intensities",
           :url => 'https://docs.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdGZZWmZtWEJlYzhRNXlPdWpBTldlcUE&output=csv' do
      key   'name',
      store 'electricity_intensity',   :units_field_name => 'electricity_intensity_units'
      store 'natural_gas_intensity',   :units_field_name => 'natural_gas_intensity_units'
      store 'fuel_oil_intensity',      :units_field_name => 'fuel_oil_intensity_units'
      store 'district_heat_intensity', :units_field_name => 'district_heat_intensity_units'
    end
    
    process "Convert natural gas intensities to metric units" do
      conversion_factor = 2.83168466 # Google: 2.83168466 cubic m / 100 cubic ft
      where(:natural_gas_intensity_units => 'hundred_cubic_feet_per_room_night').update_all(%{
        natural_gas_intensity = 1.0 * natural_gas_intensity * #{conversion_factor},
        natural_gas_intensity_units = 'cubic_metres_per_room_night'
      })
    end
    
    process "Convert fuel oil intensities to metric units" do
      conversion_factor = 3.78541178 # Google: 3.78541178 l / gal
      where(:fuel_oil_intensity_units => 'gallons_per_room_night').update_all(%{
        fuel_oil_intensity = 1.0 * fuel_oil_intensity * #{conversion_factor},
        fuel_oil_intensity_units = 'litres_per_room_night'
      })
    end
    
    process "Convert district heat intensities to metric units" do
      conversion_factor = 1.05505585 # Google: 1.05505585 MJ / 1000 Btu
      where(:district_heat_intensity_units => 'thousand_btu_per_room_night').update_all(%{
        district_heat_intensity = 1.0 * district_heat_intensity * #{conversion_factor},
        district_heat_intensity_units = 'megajoules_per_room_night'
      })
    end
  end
end
