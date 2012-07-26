class FlightDistanceClass < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "flight_distance_classes"
  (
     "name"               CHARACTER VARYING(255) NOT NULL,
     "distance"           FLOAT,
     "distance_units"     CHARACTER VARYING(255),
     "min_distance"       FLOAT,
     "min_distance_units" CHARACTER VARYING(255),
     "max_distance"       FLOAT,
     "max_distance_units" CHARACTER VARYING(255)
  );
ALTER TABLE "flight_distance_classes" ADD PRIMARY KEY ("name")
EOS

  self.primary_key = "name"
  
  def self.find_by_distance(distance)
    first :conditions => arel_table[:min_distance].lt(distance.to_f).and(arel_table[:max_distance].gteq(distance.to_f))
  end
  

  warn_unless_size 2
end
