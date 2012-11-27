begin
  require 'rgeo-shapefile'
rescue LoadError
  puts '[Earth] You need to install the rgeo-shapefile gem to mine PhotovoltaicIrradiance from scratch'
  exit
end
require 'unix_utils'

PhotovoltaicIrradiance.class_eval do
  data_miner do
    process 'Import the NREL Lower 48 Global Horizontal Irradiance shapefile' do
      zip = UnixUtils.curl 'http://www.nrel.gov/gis/cfm/data/GIS_Data_Technology_Specific/United_States/Solar/High_Resolution/Lower_48_LATTILT_High_Resolution.zip'
      Dir.chdir UnixUtils.unzip(zip) do
        RGeo::Shapefile::Reader.open('us9805_latilt.shp') do |shapefile|
          shapefile.each do |record|
            data = record.attributes
            pvi = PhotovoltaicIrradiance.new :jan_avg => data['JAN'],
              :feb_avg => data['FEB'],
              :mar_avg => data['MAR'],
              :apr_avg => data['APR'],
              :may_avg => data['MAY'],
              :jun_avg => data['JUN'],
              :jul_avg => data['JUL'],
              :aug_avg => data['AUG'],
              :sep_avg => data['SEP'],
              :oct_avg => data['OCT'],
              :nov_avg => data['NOV'],
              :dec_avg => data['DEC'],
              :annual_avg => data['ANNUAL'],
              :units => 'kilowatt_hours_per_square_metre_per_day',
              :geometry => record.geometry
            pvi.id = data['ID']
            pvi.save!
          end
        end
      end
    end
  end
end
