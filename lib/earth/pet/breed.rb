class Breed < ActiveRecord::Base
  set_primary_key :name
  
  has_many :breed_genders, :foreign_key => 'breed_name'
  belongs_to :species, :foreign_key => 'species_name'
  
  create_table do
    string   'name'
    string  'species_name'
    float    'weight'
    string   'weight_units'
  end
end
