class EgridCountry < ActiveRecord::Base
  self.primary_key = "name"
  
  class << self
    def us
      find_by_name 'US'
    end
  end
  
  col :name
  col :generation, :type => :float
  col :generation_units
  col :imports, :type => :float
  col :imports_units
  col :consumption, :type => :float
  col :consumption_units
end
