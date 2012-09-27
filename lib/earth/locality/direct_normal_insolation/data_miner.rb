begin
  require 'geo_ruby'
rescue LoadError
  puts '[Earth] You need to install the geo_ruby gem to mine Insolation from scratch'
  exit
end
begin
  require 'dbf'
rescue LoadError
  puts '[Earth] You need to install the dbf gem to mine Insolation from scratch'
  exit
end
require 'unix_utils'

DirectNormalInsolation.class_eval do
  data_miner do
    process 'Download and import Direct Normal Insolation shapefile from NREL at http://www.nrel.gov/gis/data_solar.html' do
      zip = UnixUtils.curl 'http://www.nrel.gov/gis/cfm/data/GIS_Data_Technology_Specific/United_States/Solar/High_Resolution/Lower_48_DNI_High_Resolution.zip'
      Dir.chdir UnixUtils.unzip(zip) do
        GeoRuby::Shp4r::ShpFile.open('us9805_dni.shp') do |shapefile|
          counter = 1
          shapefile.each do |record|
            shape = record.geometry.envelope
            data = record.data
            DirectNormalInsolation.create :id => counter,
              :nw_lat => shape.upper_corner.y,
              :nw_lon => shape.upper_corner.x,
              :se_lat => shape.lower_corner.y,
              :se_lon => shape.lower_corner.x,
              :jan_average => data.dni01,
              :feb_average => data.dni02,
              :mar_average => data.dni03,
              :apr_average => data.dni04,
              :may_average => data.dni05,
              :jun_average => data.dni06,
              :jul_average => data.dni07,
              :aug_average => data.dni08,
              :sep_average => data.dni09,
              :oct_average => data.dni10,
              :nov_average => data.dni11,
              :dec_average => data.dni12,
              :annual_average => data.dniann
            counter += 1
          end
        end
      end
    end
  end
end
