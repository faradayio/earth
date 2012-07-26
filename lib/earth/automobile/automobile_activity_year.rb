class AutomobileActivityYear < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "automobile_activity_years"
  (
     "activity_year"             INTEGER NOT NULL,
     "hfc_emission_factor"       FLOAT,
     "hfc_emission_factor_units" CHARACTER VARYING(255)
  );
ALTER TABLE "automobile_activity_years" ADD PRIMARY KEY ("activity_year")
EOS

  self.primary_key = "activity_year"
  
  # for calculating hfc ef
  has_many :activity_year_types, :foreign_key => :activity_year, :primary_key => :activity_year, :class_name => 'AutomobileActivityYearType'
  
  # Used by Automobile and AutomobileTrip
  def self.find_by_closest_year(year)
    if year > maximum(:activity_year)
      where(:activity_year => maximum(:activity_year)).first
    else
      where(:activity_year => [year, minimum(:activity_year)].max).first
    end
  end
  
  
  warn_unless_size 15
end
