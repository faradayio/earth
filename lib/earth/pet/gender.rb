class Gender < ActiveRecord::Base
  set_primary_key :name
  
  has_many :pets
  has_many :breed_genders, :foreign_key => 'gender_name'
  
  data_miner do
    tap "Brighter Planet's gender info", Earth.taps_server
  end
end
