class FlightDistanceClass < ActiveRecord::Base
  set_primary_key :name
  
  def self.find_by_distance(distance)
    first :conditions => arel_table[:min_distance].lteq(distance).and(arel_table[:max_distance].gt(distance))
  end
  
  col :name
  col :distance, :type => :float
  col :distance_units
  col :min_distance, :type => :float
  col :min_distance_units
  col :max_distance, :type => :float
  col :max_distance_units
  col :passengers, :type => :float
end