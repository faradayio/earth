Breed.class_eval do
  data_miner do
    import "Brighter Planet's list of cat and dog breeds",
           :url => 'http://static.brighterplanet.com/science/data/consumables/pets/breed_genders.csv',
           :encoding => 'ISO-8859-1',
           :select => proc { |row| row['gender'].blank? } do
      key 'name'
      store 'species_name', :field_name => 'species'
      store 'weight', :from_units => :pounds, :to_units => :kilograms
    end
    
    import "a list of horse breeds", :url => 'http://www.freebase.com/type/exporttypeinstances/base/horses/horse_breed?page=0&filter_mode=type&filter_view=table&show%01p%3D%2Ftype%2Fobject%2Fname%01index=0&show%01p%3D%2Fcommon%2Ftopic%2Fimage%01index=1&show%01p%3D%2Fcommon%2Ftopic%2Farticle%01index=2&sort%01p%3D%2Ftype%2Fobject%2Ftype%01p%3Dlink%01p%3D%2Ftype%2Flink%2Ftimestamp%01index=false&=&exporttype=csv-8' do
      key 'name', :field_name => 'Name'
      store 'species_name', :static => 'horse'
    end
  end
end
