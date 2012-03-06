# FIXME TODO try to clean up this data
ZipCode.class_eval do
  # sabshere 9/20/10 this isn't called anywhere
  # def set_latitude_and_longitude
  #   return if latitude.present? and longitude.present?
  #   a = Geokit::Geocoders::YahooGeocoder.geocode name
  #   update_attributes! :latitude => a.lat, :longitude => a.lng
  # end
  
  data_miner do
    import 'the Mapping Hacks zipcode database',
           :url => 'http://archive.data.brighterplanet.com/zipcode.zip', # http://mappinghacks.com/data/zipcode.zip'
           :filename => 'zipcode.csv' do
      key   'name', :field_name => 'zip', :sprintf => '%05d'
      store 'state_postal_abbreviation', :field_name => 'state'
      store 'description', :field_name => 'city'
      store 'latitude'
      store 'longitude'
    end
    
    import 'a list of zipcode states and eGRID Subregions from the US EPA',
           :url => 'http://www.epa.gov/cleanenergy/documents/egridzips/Power_Profiler_Zipcode_Tool_v3-2.xlsx',
           :sheet => 'Zip-subregion' do
      key   'name', :field_name => 'ZIP (character)'
      store 'state_postal_abbreviation', :field_name => 'State'
      store 'egrid_subregion_abbreviation', :field_name => 'Primary eGRID Subregion'
    end
    
    import 'a Brighter Planet-created list of zipcode Climate Divisions',
           :url => 'http://static.brighterplanet.com/science/data/geography/zip_code_name-climate_division_name.csv' do
      key   'name', :field_name => 'zip_code_name', :sprintf => '%05d'
      store 'climate_division_name'
    end
    
    # NOTE: ZCTAs are not zip codes but are based on the most common zip code in the area they cover - see http://www.census.gov/geo/ZCTA/zcta.html
    import 'US Census 2010 zip code tabulation area populations',
           :url => 'http://www.census.gov/geo/www/2010census/zcta_rel/zcta_county_rel_10.txt' do
      key 'name', :field_name => 'ZCTA5', :sprintf => '%05d'
      store 'population', :field_name => 'ZPOP'
    end
    
    import 'misc zip code data not included in other sources',
           :url => 'https://docs.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdHFYaUE1cEdHTzZCcTFQOEZOTGVUemc&output=csv' do
      key 'name', :sprintf => '%05d'
      store 'state_postal_abbreviation'
      store 'egrid_subregion_abbreviation'
    end
  end
end
