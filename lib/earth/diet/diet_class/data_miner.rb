DietClass.class_eval do
  data_miner do
    import "a Brighter Planet-defined list of diet classes and food group caloric distributions",
           :url => 'http://static.brighterplanet.com/science/data/consumables/diets/diet_classes.csv' do
      key   'name'
      store 'intensity'
      store 'red_meat_share'
      store 'poultry_share'
      store 'fish_share'
      store 'eggs_share'
      store 'nuts_share'
      store 'dairy_share'
      store 'cereals_and_grains_share'
      store 'fruit_share'
      store 'vegetables_share'
      store 'oils_and_sugars_share'
    end
  end
end

