class EgridCountry < ActiveRecord::Base
  self.primary_key = "name"
  
  class << self
    def us
      find_by_name 'U.S.'
    end
  end
  
  col :name
  col :generation, :type => :float
  col :generation_units
  col :foreign_interchange, :type => :float
  col :foreign_interchange_units
  col :domestic_interchange, :type => :float
  col :domestic_interchange_units
  col :consumption, :type => :float
  col :consumption_units
  col :loss_factor, :type => :float
  
  warn_unless_size 1
  warn_if_any_nulls
end
