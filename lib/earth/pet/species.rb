class Species < ActiveRecord::Base
  set_primary_key :name
  
  has_many :pets
  
  scope :thoroughly_researched, :conditions => 'marginal_dietary_requirement IS NOT NULL'
  
  falls_back_on :diet_emission_intensity => lambda { weighted_average :diet_emission_intensity, :weighted_by => :population }, # kg CO2 / joule
                :marginal_dietary_requirement => lambda { (thoroughly_researched.map(&:weighted_diet_size).sum / thoroughly_researched.sum(:population) ) / thoroughly_researched.weighted_average(:weight, :weighted_by => :population)}, # joules
                :fixed_dietary_requirement => 0, # force a zero intercept to be respectful of our tiny tiny animal friends
                :weight => lambda { weighted_average :weight, :weighted_by => :population } # kg

  data_miner do
    tap "Brighter Planet's species data", TAPS_SERVER
  end
  
  class << self
    def [](name)
      find_by_name name.to_s
    end
  end
  
  def diet_size
    return unless weight and marginal_dietary_requirement and fixed_dietary_requirement
    weight * marginal_dietary_requirement + fixed_dietary_requirement
  end
  
  def weighted_diet_size
    return unless _diet_size = diet_size and _population = population
    _diet_size * _population
  end
  
  def to_s
    name
  end
  
  def cat?
    eql? self.class[:cat]
  end
end
