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

PhotovoltaicInsolation.class_eval do
  data_miner do
    process 'Download and import PV Insolation shapefile from NREL at http://www.nrel.gov/gis/data_solar.html' do
      zip = UnixUtils.curl 'http://www.nrel.gov/gis/cfm/data/GIS_Data_Technology_Specific/United_States/Solar/High_Resolution/Lower_48_LATTILT_High_Resolution.zip'
      Dir.chdir UnixUtils.unzip(zip) do
        GeoRuby::Shp4r::ShpFile.open('us9805_latilt.shp') do |shapefile|
          shapefile.each do |record|
            shape = record.geometry.envelope
            data = record.data
            PhotovoltaicInsolation.create :nw_lat => shape.upper_corner.y,
               :nw_lon => shape.upper_corner.x,
               :se_lat => shape.lower_corner.y,
               :se_lon => shape.lower_corner.x,
               :jan_average => data.jan,
               :feb_average => data.feb,
               :mar_average => data.mar,
               :apr_average => data.apr,
               :may_average => data.may,
               :jun_average => data.jun,
               :jul_average => data.jul,
               :aug_average => data.aug,
               :sep_average => data.sep,
               :oct_average => data.oct,
               :nov_average => data.nov,
               :dec_average => data.dec,
               :annual_average => data.annual
          end
        end
      end
    end
  end
end
