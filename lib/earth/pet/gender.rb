class Gender < ActiveRecord::Base
  set_primary_key :name
  
  has_many :breed_genders, :foreign_key => 'gender_name'
  
  create_table do
    string 'name'
  end
end
