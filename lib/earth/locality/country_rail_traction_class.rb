class CountryRailTractionClass < ActiveRecord::Base
  set_primary_key :name
  
  col :name
  col :country_iso_3166_code
  col :rail_traction_name
  col :rail_class_name
  col :electricity_intensity, :type => :float
  col :electricity_intensity_units
  col :diesel_intensity, :type => :float
  col :diesel_intensity_units
  col :emission_factor, :type => :float
  col :emission_factor_units
end
