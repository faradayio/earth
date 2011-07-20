class BreedGender < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :breed, :foreign_key => 'breed_name'
  belongs_to :gender, :foreign_key => 'gender_name'
  
  force_schema do
    string   'name'
    string   'breed_name'
    string   'gender_name'
    float    'weight'
    string   'weight_units'
  end
end
