class GreenhouseGas < ActiveRecord::Base
  set_primary_key :name
    
  class << self
    def [](abbreviation)
      find_by_abbreviation abbreviation.to_s
    end
  end
  
  col :name
  col :abbreviation
  col :ipcc_report
  col :time_horizon, :type => :integer
  col :time_horizon_units
  col :global_warming_potential, :type => :integer
end