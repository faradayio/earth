class ClimateDivision < ActiveRecord::Base
  set_primary_key :name
  
  has_many :zip_codes, :foreign_key => 'climate_division_name'
  belongs_to :state, :foreign_key => 'state_postal_abbreviation'
  
  RADIUS = 750
  
  def climate_zone_number
    if cooling_degree_days < 2000
      if heating_degree_days > 7000
        1
      elsif heating_degree_days > 5499
        2
      elsif heating_degree_days > 3999
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
  col :cooling_degree_days, :type => :float
  col :state_postal_abbreviation
end
