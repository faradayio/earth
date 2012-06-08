class AutomobileActivityYear < ActiveRecord::Base
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
  
  col :activity_year, :type => :integer
  col :hfc_emission_factor, :type => :float
  col :hfc_emission_factor_units
end
