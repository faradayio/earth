begin
  require 'rgeo-shapefile'
rescue LoadError
  puts '[Earth] You need to install the rgeo-shapefile gem to mine DirectNormalIrradiance from scratch'
  exit
end
require 'unix_utils'

DirectNormalIrradiance.class_eval do
  data_miner do
    process 'Import the NREL Lower 48 Direct Normal Irradiance shapefile' do
      zip = UnixUtils.curl 'http://www.nrel.gov/gis/cfm/data/GIS_Data_Technology_Specific/United_States/Solar/High_Resolution/Lower_48_DNI_High_Resolution.zip'
      Dir.chdir UnixUtils.unzip(zip) do
        RGeo::Shapefile::Reader.open('us9805_dni.shp') do |shapefile|
          shapefile.each do |record|
            data = record.attributes
            dni = DirectNormalIrradiance.new :jan_avg => data['DNI01'],
              :feb_avg => data['DNI02'],
              :mar_avg => data['DNI03'],
              :apr_avg => data['DNI04'],
              :may_avg => data['DNI05'],
              :jun_avg => data['DNI06'],
              :jul_avg => data['DNI07'],
              :aug_avg => data['DNI08'],
              :sep_avg => data['DNI09'],
              :oct_avg => data['DNI10'],
              :nov_avg => data['DNI11'],
              :dec_avg => data['DNI12'],
              :annual_avg => data['DNIANN'],
              :units => 'kilowatt_hours_per_square_metre_per_day',
              :geometry => record.geometry
            dni.id = data['ID']
            dni.save!
          end
        end
      end
    end
  end
end
