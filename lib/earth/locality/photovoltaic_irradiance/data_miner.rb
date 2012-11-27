begin
  require 'geo_ruby'
rescue LoadError
  puts '[Earth] You need to install the geo_ruby gem to mine PhotovoltaicIrradiance from scratch'
  exit
end
begin
  require 'dbf'
rescue LoadError
  puts '[Earth] You need to install the dbf gem to mine PhotovoltaicIrradiance from scratch'
  exit
end
require 'unix_utils'

PhotovoltaicIrradiance.class_eval do
  data_miner do
    import 'Photovoltaic Irradiance (tilt = latitude) shapefile from NREL at http://www.nrel.gov/gis/data_solar.html',
          :url => 'http://www.nrel.gov/gis/cfm/data/GIS_Data_Technology_Specific/United_States/Solar/High_Resolution/Lower_48_LATTILT_High_Resolution.zip',
          :format => :shp do
      key :row_hash
      store 'nw_lat',         :field_name => 'upper_corner_y'
      store 'nw_lon',         :field_name => 'upper_corner_x'
      store 'se_lat',         :field_name => 'lower_corner_y'
      store 'se_lon',         :field_name => 'lower_corner_x'
      store 'jan_average',    :field_name => 'JAN'
      store 'feb_average',    :field_name => 'FEB'
      store 'mar_average',    :field_name => 'MAR'
      store 'apr_average',    :field_name => 'APR'
      store 'may_average',    :field_name => 'MAY'
      store 'jun_average',    :field_name => 'JUN'
      store 'jul_average',    :field_name => 'JUL'
      store 'aug_average',    :field_name => 'AUG'
      store 'sep_average',    :field_name => 'SEP'
      store 'oct_average',    :field_name => 'OCT'
      store 'nov_average',    :field_name => 'NOV'
      store 'dec_average',    :field_name => 'DEC'
      store 'annual_average', :field_name => 'ANNUAL'
      store 'units', :static => 'kilowatt_hours_per_square_metre_per_day'
    end
  end
end
