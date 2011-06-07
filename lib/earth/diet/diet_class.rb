class DietClass < ActiveRecord::Base
  set_primary_key :name
  
  class << self
    def fallback
      find_by_name 'standard'
    end
  end
  
  create_table do
    string 'name'
    float  'intensity'
    string 'intensity_units'
    float  'red_meat_share'
    float  'poultry_share'
    float  'fish_share'
    float  'eggs_share'
    float  'nuts_share'
    float  'dairy_share'
    float  'cereals_and_grains_share'
    float  'fruit_share'
    float  'vegetables_share'
    float  'oils_and_sugars_share'
  end
end
