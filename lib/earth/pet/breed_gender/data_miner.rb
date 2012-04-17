BreedGender.class_eval do
  data_miner do
    import "Brighter Planet's list of cat and dog breeds, genders, and weights",
           :url => 'http://static.brighterplanet.com/science/data/consumables/pets/breed_genders.csv',
           :encoding => 'ISO-8859-1',
           :select => proc { |row| row['gender'].present? } do
      key 'name', :synthesize => proc { |row| row['name'] + ' ' + row['gender'] }
      store 'breed_name', :field_name => 'name'
      store 'gender_name', :field_name => 'gender'
      store 'weight', :from_units => :pounds, :to_units => :kilograms
    end
  end
end
