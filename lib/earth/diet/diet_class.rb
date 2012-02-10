class DietClass < ActiveRecord::Base
  self.primary_key = "name"
  
  class << self
    def fallback
      find_by_name 'standard'
    end
  end
  
  col :name
  col :intensity, :type => :float
  col :intensity_units
  col :red_meat_share, :type => :float
  col :poultry_share, :type => :float
  col :fish_share, :type => :float
  col :eggs_share, :type => :float
  col :nuts_share, :type => :float
  col :dairy_share, :type => :float
  col :cereals_and_grains_share, :type => :float
  col :fruit_share, :type => :float
  col :vegetables_share, :type => :float
  col :oils_and_sugars_share, :type => :float
end
