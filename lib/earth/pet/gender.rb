class Gender < ActiveRecord::Base
  self.primary_key = :name
  
  has_many :breed_genders, :foreign_key => 'gender_name'
  
  col :name
end
