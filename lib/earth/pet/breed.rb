class Breed < ActiveRecord::Base
  self.primary_key = "name"
  
  has_many :breed_genders, :foreign_key => 'breed_name'
  belongs_to :species, :foreign_key => 'species_name'
  
  col :name
  col :species_name
  col :weight, :type => :float
  col :weight_units
end
