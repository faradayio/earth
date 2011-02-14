BreedGender.class_eval do
  data_miner do
    schema Earth.database_options do
      string   'name'
      string   'breed_name'
      string   'gender_name'
      float    'weight'
      string   'weight_units'
    end
    
    import "Brighter Planet's list of cat and dog breeds, genders, and weights",
           :url => 'http://static.brighterplanet.com/science/data/consumables/pets/breed_genders.csv',
           :select => lambda { |row| row['gender'].present? } do
      key 'name', :synthesize => lambda { |row| row['name'] + ' ' + row['gender'] }
      store 'breed_name', :field_name => 'name'
      store 'gender_name', :field_name => 'gender'
      store 'weight', :from_units => :pounds, :to_units => :kilograms
    end
  end
end
