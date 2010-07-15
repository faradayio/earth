FoodGroup.class_eval do
  data_miner do
    schema :options => 'ENGINE=InnoDB default charset=utf8' do
      string  'name'
      float   'intensity'
      string  'intensity_units'
      float   'energy'
      string  'energy_units'
      string  'suggested_imperial_measurement' # ?
    end
    
    import "a list of food groups and their emissions intensities",
           :url => 'http://static.brighterplanet.com/science/data/consumables/diets/food_groups.csv' do
      key   'name'
      store 'intensity', :units => :grams_per_kilocalorie #FIXME TODO make sure diet expects kg / joule and then do :from_units => :grams_per_kilocalorie, :to_units => :kilograms_per_joule
    end
    
    import "energy and units",
           :url => 'http://spreadsheets.google.com/pub?key=trkBEq5oFnUQE76gQ6VpQgw' do
      key   'name'
      store 'energy', :units => 'unknown' #FIXME this needs to be "kilocalories per" and then whatever the suggested imperial measurement is
      store 'suggested_imperial_measurement', :field_name => 'friendly_units'
    end
  end
end

