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

Insolation.class_eval do
  data_miner do
    process 'Download and import PV Insolation shapefile from NREL at http://www.nrel.gov/gis/data_solar.html' do
      zip = UnixUtils.curl 'http://www.nrel.gov/gis/cfm/data/GIS_Data_Technology_Specific/United_States/Solar/High_Resolution/Lower_48_LATTILT_High_Resolution.zip'
      Dir.chdir UnixUtils.unzip(zip) do
        GeoRuby::Shp4r::ShpFile.open('us9805_latilt.shp') do |shapefile|
          shapefile.each do |record|
            shape = record.geometry.envelope
            data = record.data
            zip_code = ZipCode.find :first, :origin => [shape.center.y, shape.center.x], :within => 100
            Insolation.create :zip_code_name => zip_code.name,
               :nw_lat => shape.upper_corner.y,
               :nw_lon => shape.upper_corner.x,
               :se_lat => shape.lower_corner.y,
               :se_lon => shape.lower_corner.x,
               :jan_insolation => data.jan,
               :feb_insolation => data.feb,
               :mar_insolation => data.mar,
               :apr_insolation => data.apr,
               :may_insolation => data.may,
               :jun_insolation => data.jun,
               :jul_insolation => data.jul,
               :aug_insolation => data.aug,
               :sep_insolation => data.sep,
               :oct_insolation => data.oct,
               :nov_insolation => data.nov,
               :dec_insolation => data.dec,
               :average_insolation => data.annual
          end
        end
      end
    end
  end
end
