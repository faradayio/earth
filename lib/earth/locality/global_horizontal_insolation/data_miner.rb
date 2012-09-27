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

GlobalHorizontalInsolation.class_eval do
  data_miner do
    process 'Download and import Global Horizontal Insolation shapefile from NREL at http://www.nrel.gov/gis/data_solar.html' do
      zip = UnixUtils.curl 'http://www.nrel.gov/gis/cfm/data/GIS_Data_Technology_Specific/United_States/Solar/High_Resolution/Lower_48_GHI_High_Resolution.zip'
      Dir.chdir UnixUtils.unzip(zip) do
        GeoRuby::Shp4r::ShpFile.open('l48_ghi_10km.shp') do |shapefile|
          counter = 1
          shapefile.each do |record|
            shape = record.geometry.envelope
            data = record.data
            GlobalHorizontalInsolation.create :id => counter,
              :nw_lat => shape.upper_corner.y,
              :nw_lon => shape.upper_corner.x,
              :se_lat => shape.lower_corner.y,
              :se_lon => shape.lower_corner.x,
              :jan_average => data.ghi01,
              :feb_average => data.ghi02,
              :mar_average => data.ghi03,
              :apr_average => data.ghi04,
              :may_average => data.ghi05,
              :jun_average => data.ghi06,
              :jul_average => data.ghi07,
              :aug_average => data.ghi08,
              :sep_average => data.ghi09,
              :oct_average => data.ghi10,
              :nov_average => data.ghi11,
              :dec_average => data.ghi12,
              :annual_average => data.ghiann
            counter += 1
          end
        end
      end
    end
  end
end
