require 'earth/model'
require 'falls_back_on'

require 'earth/pet/breed'

class Species < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS

CREATE TABLE species
  (
     name                               CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     population                         INTEGER,
     diet_emission_intensity            FLOAT,
     diet_emission_intensity_units      CHARACTER VARYING(255),
     weight                             FLOAT,
     weight_units                       CHARACTER VARYING(255),
     marginal_dietary_requirement       FLOAT,
     marginal_dietary_requirement_units CHARACTER VARYING(255),
     fixed_dietary_requirement          FLOAT,
     fixed_dietary_requirement_units    CHARACTER VARYING(255),
     minimum_weight                     FLOAT,
     minimum_weight_units               CHARACTER VARYING(255),
     maximum_weight                     FLOAT,
     maximum_weight_units               CHARACTER VARYING(255)
  );

EOS

  self.primary_key = "name"
  
  has_many :breeds, :foreign_key => 'species_name'
  
  scope :thoroughly_researched, :conditions => 'marginal_dietary_requirement IS NOT NULL'
  
  falls_back_on :diet_emission_intensity => lambda { weighted_average :diet_emission_intensity, :weighted_by => :population }, # kg CO2 / joule
                :marginal_dietary_requirement => lambda { Species.marginal_dietary_requirement_fallback },
                :fixed_dietary_requirement => 0, # force a zero intercept to be respectful of our tiny tiny animal friends
                :weight => lambda { weighted_average :weight, :weighted_by => :population } # kg

  class << self
    def [](name)
      find_by_name name.to_s
    end

    def marginal_dietary_requirement_fallback
      total_diet_size = thoroughly_researched.map(&:weighted_diet_size).sum.to_f
      total_population = thoroughly_researched.sum(:population)
      return 0.0 unless total_population > 0.0
      average_weight = thoroughly_researched.weighted_average(:weight, :weighted_by => :population)
      return 0.0 unless average_weight > 0.0
      (total_diet_size / total_population) / average_weight
    end
  end
  
  def diet_size
    return unless weight and marginal_dietary_requirement and fixed_dietary_requirement
    weight.to_f * marginal_dietary_requirement + fixed_dietary_requirement
  end
  
  def weighted_diet_size
    return unless _diet_size = diet_size and _population = population
    _diet_size.to_f * _population
  end
  
  def to_s
    name
  end
  
  def cat?
    eql? self.class[:cat]
  end

  warn_unless_size 18
end
