class Gender < ActiveRecord::Base
  self.primary_key = "name"
  
  has_many :breed_genders, :foreign_key => 'gender_name'
  
  col :name

  warn_unless_size 2
end
