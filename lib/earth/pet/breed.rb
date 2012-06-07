class Breed < ActiveRecord::Base
  self.primary_key = "name"
  
  has_many :breed_genders, :foreign_key => 'breed_name'
  belongs_to :species, :foreign_key => 'species_name'
  
  col :name
  col :species_name
  col :weight, :type => :float
  col :weight_units

  warn_if_nulls_except(
    :weight,
    :weight_units
  )

  warn_unless_size 522
end
