class DietClass < ActiveRecord::Base
  set_primary_key :name
  
  index :name
  has_many :diets
  
  data_miner do
    tap "Brighter Planet's diet class data", Earth.taps_server
  end
  
  class << self
    def fallback
      find_by_name 'standard'
    end
  end
end
