class AutomobileActivityYearTypeFuel < ActiveRecord::Base
  self.primary_key = "name"
  
  # Used by AutomobileFuel to get records from latest activity year
  def self.latest
    where(:activity_year => maximum(:activity_year))
  end
  
  col :name
  col :activity_year, :type => :integer
  col :type_name
  col :fuel_common_name
  col :distance, :type => :float
  col :distance_units
  col :fuel_consumption, :type => :float
  col :fuel_consumption_units
end
