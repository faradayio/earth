begin
  require 'geo_ruby'
rescue LoadError
  puts '[Earth] You need to install the geo_ruby gem to mine GlobalHorizontalIrradiance from scratch'
  exit
end
begin
  require 'dbf'
rescue LoadError
  puts '[Earth] You need to install the dbf gem to mine GlobalHorizontalIrradiance from scratch'
  exit
end
require 'unix_utils'

GlobalHorizontalIrradiance.class_eval do
  data_miner do
    import 'Global Horizontal Irradiance shapefile from NREL at http://www.nrel.gov/gis/data_solar.html',
          :url => 'http://www.nrel.gov/gis/cfm/data/GIS_Data_Technology_Specific/United_States/Solar/High_Resolution/Lower_48_GHI_High_Resolution.zip',
          :format => :shp do
      key :row_hash
      store 'nw_lat',         :field_name => 'upper_corner_y'
      store 'nw_lon',         :field_name => 'upper_corner_x'
      store 'se_lat',         :field_name => 'lower_corner_y'
      store 'se_lon',         :field_name => 'lower_corner_x'
      store 'jan_average',    :field_name => 'GHI01'
      store 'feb_average',    :field_name => 'GHI02'
      store 'mar_average',    :field_name => 'GHI03'
      store 'apr_average',    :field_name => 'GHI04'
      store 'may_average',    :field_name => 'GHI05'
      store 'jun_average',    :field_name => 'GHI06'
      store 'jul_average',    :field_name => 'GHI07'
      store 'aug_average',    :field_name => 'GHI08'
      store 'sep_average',    :field_name => 'GHI09'
      store 'oct_average',    :field_name => 'GHI10'
      store 'nov_average',    :field_name => 'GHI11'
      store 'dec_average',    :field_name => 'GHI12'
      store 'annual_average', :field_name => 'GHIANN'
      store 'units', :static => 'kilowatt_hours_per_square_metre_per_day'
    end
  end
end
