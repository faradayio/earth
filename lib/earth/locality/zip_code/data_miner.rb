ZipCode.class_eval do
  data_miner do
    import 'the Mapping Hacks zipcode database',
           :url => 'http://mappinghacks.com/data/zipcode.zip', # http://archive.data.brighterplanet.com/zipcode.zip
           :filename => 'zipcode.csv' do
      key   'name', :field_name => 'zip', :sprintf => '%05d'
      store 'state_postal_abbreviation', :field_name => 'state'
      store 'description', :field_name => 'city'
      store 'latitude'
      store 'longitude'
    end
    
    import 'a list of zipcode states and eGRID Subregions from the US EPA',
           :url => 'http://www.epa.gov/cleanenergy/documents/egridzips/Power_Profiler_Zipcode_Tool_v4-0.xlsx',
           :sheet => 'Zip-subregion' do
      key   'name', :field_name => 'ZIP (character)'
      store 'state_postal_abbreviation', :field_name => 'State'
      store 'egrid_subregion_abbreviation', :field_name => 'Primary eGRID Subregion'
    end
    
    import 'a Brighter Planet-created list of zipcode Climate Divisions',
           :url => "file://#{Earth::DATA_DIR}/locality/zip_climate_divisions.csv" do
      key   'name', :field_name => 'zip_code_name', :sprintf => '%05d'
      store 'climate_division_name'
    end
    
    # NOTE: ZCTAs are not zip codes but are based on the most common zip code in the area they cover - see http://www.census.gov/geo/ZCTA/zcta.html
    import 'US Census 2010 zip code tabulation area populations',
           :url => 'http://www.census.gov/geo/maps-data/data/docs/rel/zcta_county_rel_10.txt' do
      key 'name', :field_name => 'ZCTA5', :sprintf => '%05d'
      store 'population', :field_name => 'ZPOP'
    end
    
    import 'misc zip code data not included in other sources',
           :url => "file://#{Earth::DATA_DIR}/locality/misc_zip_data.csv" do
      key 'name', :sprintf => '%05d'
      store 'state_postal_abbreviation', :nullify => true
      store 'egrid_subregion_abbreviation', :nullify => true
    end
    
    process "Derive missing state postal abbreviations from climate division name" do
      where("state_postal_abbreviation IS NULL AND climate_division_name IS NOT NULL").update_all %{
        state_postal_abbreviation = LEFT(climate_division_name, 2)
      }
    end
    
    process "Data mine Country because it's like a belongs_to association" do
      Country.run_data_miner!
    end
    
    # FIXME TODO figure out how to speed this up then re-enable it
    # process "Look up missing latitude and longitude" do
    #   where("latitude IS NULL OR longitude IS NULL").each do |zip|
    #     if (location = Geokit::Geocoders::MultiGeocoder.geocode zip.name).success
    #       zip.update_attributes! :latitude => location.lat, :longitude => location.lng
    #     end
    #   end
    # end
  end
end
