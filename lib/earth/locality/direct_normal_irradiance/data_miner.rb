begin
  require 'geo_ruby'
rescue LoadError
  puts '[Earth] You need to install the geo_ruby gem to mine DirectNormalIrradiance from scratch'
  exit
end
begin
  require 'dbf'
rescue LoadError
  puts '[Earth] You need to install the dbf gem to mine DirectNormalIrradiance from scratch'
  exit
end
require 'unix_utils'

DirectNormalIrradiance.class_eval do
  data_miner do
    import 'Direct Normal Irradiance shapefile from NREL at http://www.nrel.gov/gis/data_solar.html',
          :url => 'http://www.nrel.gov/gis/cfm/data/GIS_Data_Technology_Specific/United_States/Solar/High_Resolution/Lower_48_DNI_High_Resolution.zip',
          :format => :shp do
      key :row_hash
      store 'nw_lat',         :field_name => 'upper_corner_y'
      store 'nw_lon',         :field_name => 'upper_corner_x'
      store 'se_lat',         :field_name => 'lower_corner_y'
      store 'se_lon',         :field_name => 'lower_corner_x'
      store 'jan_average',    :field_name => 'DNI01'
      store 'feb_average',    :field_name => 'DNI02'
      store 'mar_average',    :field_name => 'DNI03'
      store 'apr_average',    :field_name => 'DNI04'
      store 'may_average',    :field_name => 'DNI05'
      store 'jun_average',    :field_name => 'DNI06'
      store 'jul_average',    :field_name => 'DNI07'
      store 'aug_average',    :field_name => 'DNI08'
      store 'sep_average',    :field_name => 'DNI09'
      store 'oct_average',    :field_name => 'DNI10'
      store 'nov_average',    :field_name => 'DNI11'
      store 'dec_average',    :field_name => 'DNI12'
      store 'annual_average', :field_name => 'DNIANN'
      store 'units', :static => 'kilowatt_hours_per_square_metre_per_day'
    end
  end
end
