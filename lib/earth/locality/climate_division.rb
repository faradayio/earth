class ClimateDivision < ActiveRecord::Base
  self.primary_key = "name"
  
  has_many :zip_codes, :foreign_key => 'climate_division_name'
  belongs_to :state, :foreign_key => 'state_postal_abbreviation'
  
  RADIUS = 750
  
  def climate_zone_number
    if cooling_degree_days < 2000.degrees_fahrenheit.to(:degrees_celsius)
      if heating_degree_days > 7000.degrees_fahrenheit.to(:degrees_celsius)
        1
      elsif heating_degree_days > 5499.degrees_fahrenheit.to(:degrees_celsius)
        2
      elsif heating_degree_days > 3999.degrees_fahrenheit.to(:degrees_celsius)
        3
      else
        4
      end
    else
      5
    end
  end
  
  col :name
  col :heating_degree_days, :type => :float
  col :heating_degree_days_units
  col :cooling_degree_days, :type => :float
  col :cooling_degree_days_units
  col :state_postal_abbreviation
end
