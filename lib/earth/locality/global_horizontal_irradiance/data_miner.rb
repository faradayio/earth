begin
  require 'rgeo-shapefile'
rescue LoadError
  puts '[Earth] You need to install the rgeo-shapefile gem to mine GlobalHorizontalIrradiance from scratch'
  exit
end
require 'unix_utils'

GlobalHorizontalIrradiance.class_eval do
  data_miner do
    process 'Import the NREL Lower 48 Global Horizontal Irradiance shapefile' do
      zip = UnixUtils.curl 'http://www.nrel.gov/gis/cfm/data/GIS_Data_Technology_Specific/United_States/Solar/High_Resolution/Lower_48_GHI_High_Resolution.zip'
      Dir.chdir UnixUtils.unzip(zip) do
        RGeo::Shapefile::Reader.open('l48_ghi_10km.shp') do |shapefile|
          shapefile.each do |record|
            data = record.attributes
            ghi = GlobalHorizontalIrradiance.new :jan_avg => data['GHI01'],
              :feb_avg => data['GHI02'],
              :mar_avg => data['GHI03'],
              :apr_avg => data['GHI04'],
              :may_avg => data['GHI05'],
              :jun_avg => data['GHI06'],
              :jul_avg => data['GHI07'],
              :aug_avg => data['GHI08'],
              :sep_avg => data['GHI09'],
              :oct_avg => data['GHI10'],
              :nov_avg => data['GHI11'],
              :dec_avg => data['GHI12'],
              :annual_avg => data['GHIANN'],
              :units => 'kilowatt_hours_per_square_metre_per_day',
              :geometry => record.geometry
            ghi.id = data['ID']
            ghi.save!
          end
        end
      end
    end
  end
end
