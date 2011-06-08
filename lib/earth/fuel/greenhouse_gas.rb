class GreenhouseGas < ActiveRecord::Base
  set_primary_key :name
    
  class << self
    def [](abbreviation)
      find_by_abbreviation abbreviation.to_s
    end
  end
  
  create_table do
    string  'name'
    string  'abbreviation'
    string  'ipcc_report'
    integer 'time_horizon'
    string  'time_horizon_units'
    integer 'global_warming_potential'
  end
end
