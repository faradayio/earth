require 'earth/locality/data_miner'
CensusRegionLodgingClass.class_eval do
  data_miner do
    import "US census region lodging class fuel intensities derived from CBECS 2003",
           :url => 'https://docs.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdGkxNExTajZPSjRWU3REVks5SFJ0cmc&output=csv',
           :select => lambda { |row| row['census_region_lodging_class'].present? } do
      key   'name', :field_name => 'census_region_lodging_class'
      store 'census_region_number', :field_name => 'census_region'
      store 'lodging_class_name',    :field_name => 'lodging_class'
      store 'electricity_intensity',   :units_field_name => 'electricity_intensity_units'
      store 'natural_gas_intensity',   :units_field_name => 'natural_gas_intensity_units'
      store 'fuel_oil_intensity',      :units_field_name => 'fuel_oil_intensity_units'
      store 'district_heat_intensity', :units_field_name => 'district_heat_intensity_units'
      store 'weighting'
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
