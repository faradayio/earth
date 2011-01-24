ZipCode.class_eval do
  # sabshere 9/20/10 this isn't called anywhere
  # def set_latitude_and_longitude
  #   return if latitude.present? and longitude.present?
  #   a = Geokit::Geocoders::YahooGeocoder.geocode name
  #   update_attributes! :latitude => a.lat, :longitude => a.lng
  # end
  
  data_miner do
    schema Earth.database_options do
      string   'name'
      string   'state_postal_abbreviation'
      string   'description'
      string   'latitude'
      string   'longitude'
      string   'egrid_subregion_abbreviation'
      string   'climate_division_name'
    end
    
    import 'the Mapping Hacks zipcode database',
           :url => 'http://mappinghacks.com/data/zipcode.zip',
           :filename => 'zipcode.csv' do
      key   'name', :field_name => 'zip', :sprintf => '%05d'
      store 'state_postal_abbreviation', :field_name => 'state'
      store 'description', :field_name => 'city'
      store 'latitude'
      store 'longitude'
    end
    
    import 'a Brighter Planet-created list of zipcode eGRID Subregions',
           :url => 'http://static.brighterplanet.com/science/data/electricity/egrid/models_export/zip_subregions.csv' do
      key   'name', :field_name => 'zip', :sprintf => '%05d'
      store 'egrid_subregion_abbreviation', :field_name => 'primary_subregion'
    end
    
    import 'a Brighter Planet-created list of zipcode Climate Divisions',
           :url => 'http://static.brighterplanet.com/science/data/geography/zip_code_name-climate_division_name.csv' do
      key   'name', :field_name => 'zip_code_name', :sprintf => '%05d'
      store 'climate_division_name'
    end
  end
end
