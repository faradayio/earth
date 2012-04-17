Gender.class_eval do
  data_miner do
    import "a list of genders derived from pet breed genders",
           :url => 'http://static.brighterplanet.com/science/data/consumables/pets/breed_genders.csv',
           :select => proc { |row| row['gender'].present? } do
      key 'name', :field_name => 'gender'
    end
  end
end

