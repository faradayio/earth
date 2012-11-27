begin
  require 'rgeo-shapefile'
rescue LoadError
  puts '[Earth] You need to install the rgeo-shapefile gem to mine ClimateDivision from scratch'
  exit
end

ClimateDivision.class_eval do
  data_miner do
    process "Import the Utah State University climate divisions shapefile" do
      RGeo::Shapefile::Reader.open("#{Earth::DATA_DIR}/locality/climate_divisions/divisions.shp") do |shapefile|
        counter = 0
        shapefile.each do |record|
          data = record.attributes
          division = ClimateDivision.new :state_postal_abbreviation => data['ST'],
            :geometry => record.geometry,
            :division => [data['ST'], data['DIV']].join
          division.name = counter
          division.save!
          counter += 1
        end
      end
    end
    
    import "a list of climate divisions and their average heating and cooling degree days",
           :url => 'http://static.brighterplanet.com/science/data/climate/climate_divisions/climate_divisions.csv' do
      key 'name'
      store 'heating_degree_days', :from_units => :degrees_fahrenheit, :to_units => :degrees_celsius
      store 'cooling_degree_days', :from_units => :degrees_fahrenheit, :to_units => :degrees_celsius
    end
  end
end
